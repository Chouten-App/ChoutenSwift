//
//  CustomControlsView.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//

import SwiftUI
import AVKit
import SwiftUIFontIcon
import SwiftWebVTT
import ActivityIndicatorView
import Kingfisher

extension UIFont {
    static func custom(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Failed to load custom font named \(name)")
        }
        return font
    }
}

struct GradientStop: Equatable {
    var color: Color
    var location: Double
}

extension GradientStop: VectorArithmetic {
    static var zero: GradientStop {
        GradientStop(color: .clear, location: 0)
    }
    
    static func + (lhs: GradientStop, rhs: GradientStop) -> GradientStop {
        GradientStop(color: lhs.color, location: lhs.location + rhs.location)
    }
    
    static func - (lhs: GradientStop, rhs: GradientStop) -> GradientStop {
        GradientStop(color: lhs.color, location: lhs.location - rhs.location)
    }
    
    mutating func scale(by rhs: Double) {
        location *= rhs
    }
    
    var magnitudeSquared: Double {
        location * location
    }
}

struct CustomControlsView: View {
    @Binding var streamData: VideoData
    @Binding var showUI: Bool
    @ObservedObject var playerVM: PlayerViewModel
    @Binding var number: Int
    @ObservedObject var globalData: GlobalData
    @State var progress = 0.25
    @State var isLoading: Bool = false
    @State var showEpisodeSelector: Bool = false
    @State var volumeDrag: Bool = false
    @State var showSubs: Bool = true
    
    @State var showingPopup = false
    @State var showingEpisodeSelector = false
    @State var rotation: Double = 0.0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    func secondsToMinutesSeconds(_ seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let minuteString = (minutes < 10 ? "0" : "") +  "\(minutes)"
        let secondsString = (seconds < 10 ? "0" : "") +  "\(seconds)"
        
        return minuteString + ":" + secondsString
    }
    
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        }
    
    @State private var buttonOffset: Double = -156
    @State private var textWidth: Double = 0
    @State private var skipPercentage: CGFloat = 0.0
    @State var selectedEpisode: Int = 0
    @State var startEpisodeList = 0
    @State var endEpisodeList = 50
    @State var paginationIndex = 0
    @State var animateBackward: Bool = false
    @State var animateForward: Bool = false
    @State var isMacos: Bool = false
    @State var showMacosPopover: Bool = false
    
    func getSkipPercentage(currentTime: Double, startTime: Double, endTime: Double) -> Double {
        if(startTime <= currentTime && endTime >= currentTime) {
            let timeElapsed = currentTime - startTime
            let totalTime = endTime - startTime
            let percentage = timeElapsed / totalTime
            return percentage
        }
        return 0.0
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(showUI ? 0.7 : 0.0)
                
                // subtitles
                ZStack(alignment: .bottom) {
                    if(showSubs) {
                        VStack {
                            Spacer()
                            
                            ForEach(0..<playerVM.currentSubs.count, id:\.self) {index in
                                ZStack {
                                    Color(.black).opacity(0.5)
                                    
                                    Text(LocalizedStringKey(playerVM.currentSubs[index].text.replacingOccurrences(of: "*", with: "**").replacingOccurrences(of: "_", with: "*")))
                                        .font(.system(size: 18))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                                .fixedSize()
                                .cornerRadius(6)
                            }
                        }
                        .frame(maxWidth: proxy.size.width * 0.8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 40)
                
                // ui
                ZStack(alignment: .bottomTrailing) {
                    HStack {
                        Color.clear
                            .frame(width: proxy.size.width / 3, height: 300)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture(count: 2)
                                    .onEnded({ playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)})
                                    .exclusively(before:
                                                    TapGesture()
                                        .onEnded({showUI = false})
                                                )
                            )
                        
                        Color.clear
                            .frame(width: proxy.size.width / 3, height: 300)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showUI = false
                            }
                        
                        Color.clear
                            .frame(width: proxy.size.width / 3, height: 300)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture(count: 2)
                                    .onEnded({ playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)})
                                    .exclusively(before:
                                                    TapGesture()
                                        .onEnded({showUI = false})
                                                )
                            )
                        
                    }
                    
                
                    if streamData.skips.count > 0 {
                        Button(action: {
                            
                            playerVM.isEditingCurrentTime = true
                            playerVM.currentTime = streamData.skips[0].end
                            playerVM.isEditingCurrentTime = false
                            
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(.black.opacity(0.4))
                                
                                Rectangle()
                                    .fill(.white)
                                    .offset(x: buttonOffset)
                                    .onReceive(playerVM.$currentTime) { currentTime in
                                        //viewModel.showSkipButton(currentTime: currentTime)
                                        let skipPercentage = getSkipPercentage(currentTime: currentTime, startTime: streamData.skips[0].start, endTime: streamData.skips[0].end)
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            buttonOffset = -textWidth + (textWidth * skipPercentage)
                                        }
                                    }
                                
                                
                                Text("Skip Opening")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(.white)
                                    .blendMode(BlendMode.difference)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                                    .overlay(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .onAppear {
                                                    self.textWidth = geometry.size.width
                                                    buttonOffset = -textWidth
                                                }
                                        }
                                    )
                                
                            }
                            .fixedSize()
                            .cornerRadius(12)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
                            )
                        }
                        .padding(.bottom, 70)
                        .padding(.trailing, 30)
                        .opacity(streamData.skips[0].start <= playerVM.currentTime && streamData.skips[0].end >= playerVM.currentTime ? 1.0 : 0.0)
                    }
                    
                    VStack {
                        // top part
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                ZStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .fixedSize()
                            })
                            
                            Spacer()
                                .frame(maxWidth: 12)
                            
                            
                            VStack {
                                Text("\(String(globalData.infoData!.mediaList[0][number].number)): \(globalData.infoData!.mediaList[0][number].title ?? "")")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(globalData.infoData!.titles.primary)")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 14))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                
                                Text(globalData.module?.name ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .bold()
                                    .frame(maxWidth: 120, alignment: .trailing)
                                
                                Text(playerVM.getCurrentItem() != nil ? String(Int(playerVM.getCurrentItem()!.presentationSize.width)) + "x" + String(Int(playerVM.getCurrentItem()!.presentationSize.height)) : "unknown")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: 120, alignment: .trailing)
                            }
                            .frame(maxWidth: 120, alignment: .trailing)
                             
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 12)
                        .zIndex(99)
                        Spacer()
                        // bottom part
                        VStack {
                            HStack {
                                if(playerVM.duration != nil) {
                                    Text("\(secondsToMinutesSeconds(Int(playerVM.currentTime))) / \(secondsToMinutesSeconds(Int(playerVM.duration!)))")
                                        .font(.system(size: isMacos ? 18 : 14))
                                        .bold()
                                        .foregroundColor(.white)
                                } else {
                                    Text("--:-- / --:--")
                                        .font(.system(size: isMacos ? 18 : 14))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    
                                    Image("episodes")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 24)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            Task {
                                                showingEpisodeSelector.toggle()
                                            }
                                        }
                                    
                                    Spacer()
                                        .frame(maxWidth: 34)
                                    
                                    Spacer()
                                        .frame(maxWidth: 34)
                                }
                            }
                            .padding(.bottom, -4)
                            
                            if(playerVM.duration != nil) {
                                CustomView(percentage: $playerVM.currentTime, buffered: $playerVM.buffered, isDragging: $playerVM.isEditingCurrentTime, total: playerVM.duration!, isMacos: $isMacos)
                                    .frame(height: 20)
                                    .frame(maxHeight: 20)
                                    .padding(.bottom, playerVM.isEditingCurrentTime ? 3 : 0 )
                            } else {
                                CustomView(percentage: Binding.constant(0.0), buffered: .constant(0.0), isDragging: Binding.constant(false), total: 1.0, isMacos: $isMacos)
                                    .frame(height: 20)
                                    .frame(maxHeight: 20)
                                    .padding(.bottom, 0)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, isMacos ? 60 : 24)
                    }
                    
                    // play/pause
                    HStack {
                        
                        if(playerVM.isLoading == false) {
                            Spacer()
                            ZStack {
                                Text("10")
                                    .font(.system(size: 10, weight: .bold))
                                
                                Image("goBackward")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(1.0))
                                    .rotationEffect(animateBackward ? Angle(degrees: -30) : .zero)
                                    .animation(.spring(response: 0.3), value: animateBackward)
                                    .onTapGesture {
                                        Task {
                                            await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            // add crunchy animation
                                            animateBackward = true
                                            try? await Task.sleep(nanoseconds: 400_000_000)
                                            animateBackward = false
                                        }
                                    }
                                    .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [])
                                
                                Text("-10")
                                    .font(.system(size: 18, weight: .semibold))
                                    .offset(x: animateBackward ? -40 : 0)
                                    .opacity(animateBackward ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.3), value: animateBackward)
                            }
                            
                            Spacer().frame(maxWidth: 72)
                            
                            if playerVM.isPlaying == false {
                                Button(action: {
                                    playerVM.player.play()
                                }) {
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 50)
                                        .frame(maxWidth: 42, maxHeight: 50)
                                        .foregroundColor(.white)
                                }
                                .keyboardShortcut(KeyEquivalent.space, modifiers: [])
                            } else {
                                Button(action: {
                                    playerVM.player.pause()
                                }) {
                                    Image(systemName: "pause.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 50)
                                        .frame(maxWidth: 42, maxHeight: 50)
                                        .foregroundColor(.white)
                                }
                                .keyboardShortcut(KeyEquivalent.space, modifiers: [])
                            }
                            
                            Spacer().frame(maxWidth: 72)
                            
                            ZStack {
                                Text("10")
                                    .font(.system(size: 10, weight: .bold))
                                
                                Image("goForward")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.white.opacity(1.0))
                                    .rotationEffect(animateForward ? Angle(degrees: 30) : .zero)
                                    .animation(.spring(response: 0.3), value: animateForward)
                                    .onTapGesture {
                                        Task {
                                            await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            // add crunchy animation
                                            animateForward = true
                                            try? await Task.sleep(nanoseconds: 400_000_000)
                                            animateForward = false
                                        }
                                    }
                                    .keyboardShortcut(KeyEquivalent.rightArrow, modifiers: [])
                                
                                Text("+10")
                                    .font(.system(size: 18, weight: .semibold))
                                    .offset(x: animateForward ? 40 : 0)
                                    .opacity(animateForward ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.3), value: animateForward)
                            }
                            
                            Spacer()
                            
                        }
                        else {
                            ZStack {
                                if(playerVM.hasError == false) {
                                    /*
                                    ActivityIndicatorView(isVisible: $playerVM.isLoading, type: .growingArc(.white, lineWidth: 4))
                                        .frame(maxWidth: 40, maxHeight: 40)
                                     */
                                } else {
                                    HStack {
                                        
                                        ZStack {
                                            Color(hex: "#ffFFE0E4")
                                            /*
                                            FontIcon.button(.awesome5Solid(code: .exclamation_triangle), action: {
                                                
                                            }, fontsize: 32)
                                            .foregroundColor(Color(hex: "#ffDE2627"))
                                            .padding(.bottom, 4)
                                            */
                                        }
                                        .frame(maxWidth: 62, maxHeight: 62)
                                        .cornerRadius(31)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Video Loading failed")
                                                .foregroundColor(.white)
                                                .bold()
                                                .font(.title)
                                                .padding(.leading, 4)
                                            
                                            Text("There was an error fetching the video file. Please try again later.")
                                                .foregroundColor(.white.opacity(0.7))
                                                .bold()
                                                .font(.subheadline)
                                                .frame(maxWidth: 280)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                }
                .opacity(showUI ? 1.0 : 0.0)
                .animation(.spring(response: 0.3), value: showUI)
            }
            .onAppear {
                isMacos = proxy.size.width > 900
            }
        }
        
    }
}
