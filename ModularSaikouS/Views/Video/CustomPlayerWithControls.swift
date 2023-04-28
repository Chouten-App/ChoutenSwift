//
//  CustomPlayerWithControls.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//

import SwiftUI
import AVKit
import Combine
import SwiftWebVTT

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var playerVM: PlayerViewModel
    @State var showUI: Bool
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?
        
        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            super.init()
            
            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
        }
        
        func setController(_ playerLayer: AVPlayerLayer) {
            controller = AVPictureInPictureController(playerLayer: playerLayer)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            controller?.delegate = self
        }
        
        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }
        
        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}


struct CustomPlayerWithControls: View {
    @Binding var streamData: VideoData
    @State var number: Int
    @ObservedObject var globalData: GlobalData
    @State var doneLoading = false
    @State var showUI: Bool = true
    @State var resIndex: Int = 0
    
    @StateObject private var playerVM = PlayerViewModel()
    
    init(streamData: Binding<VideoData>, number: Int, globalData: GlobalData) {
        self._streamData = streamData
        self.number = number
        self.globalData = globalData
        // we need this to use Picture in Picture
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    private var isIOS16: Bool {
        guard #available(iOS 16, *) else {
            return true
        }
        return false
    }
    
    var body: some View {
        GeometryReader {proxy in
            if streamData.sources.count > 0 {
                ZStack {
                    Color(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .ignoresSafeArea(.all)
                    
                    CustomVideoPlayer(playerVM: playerVM, showUI: showUI)
                        .overlay(
                            HStack {
                                Color.clear
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        TapGesture(count: 2)
                                            .onEnded({ playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)})
                                            .exclusively(before:
                                                            TapGesture()
                                                .onEnded({showUI = true})
                                                        )
                                    )
                                
                                Color.clear
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        showUI = true
                                    }
                                
                                Color.clear
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        TapGesture(count: 2)
                                            .onEnded({ playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)})
                                            .exclusively(before:
                                                            TapGesture()
                                                .onEnded({showUI = true})
                                                        )
                                    )
                                
                            }
                        )
                        .overlay(CustomControlsView(streamData: $streamData, showUI: $showUI, playerVM: playerVM, number: $number, globalData: globalData)
                            .padding(.horizontal, 20), alignment: .bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea(.all)
                .prefersHomeIndicatorAutoHidden(true)
                .task {
                    playerVM.setCurrentItem(AVPlayerItem(url:  URL(string: streamData.sources[0].file)!))
                    if(streamData.subtitles.count > 0) {
                        var content: String
                        var index = 0
                        
                        for sub in 0..<streamData.subtitles.count {
                            if(streamData.subtitles[sub].language == "English") {
                                index = sub
                            }
                        }
                        
                        playerVM.selectedSubtitleIndex = index
                        
                        if let url = URL(string: streamData.subtitles[index].url) {
                            do {
                                content = try String(contentsOf: url)
                                //print(content)
                            } catch {
                                // contents could not be loaded
                                content = ""
                            }
                        } else {
                            // the URL was bad!
                            content = ""
                        }
                        
                        let parser = WebVTTParser(string: content.replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_").replacingOccurrences(of: "<b>", with: "*").replacingOccurrences(of: "</b>", with: "*"))
                        let webVTT = try? parser.parse()
                        
                        playerVM.webVTT = webVTT
                    }
                    playerVM.player.play()
                }
                .onDisappear {
                    playerVM.player.pause()
                    
                    playerVM.player.replaceCurrentItem(with: nil)
                }
                .onReceive(playerVM.$currentTime) { newValue in
                }
            }
            else {
                ZStack {
                    Color(.black)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(GaugeProgressStyle())
                }
            }
        }
    }
}
