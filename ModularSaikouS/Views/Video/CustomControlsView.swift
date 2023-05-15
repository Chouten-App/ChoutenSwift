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
import PureSwiftUI

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

enum SettingsPage {
    case home
    case quality
}

struct CustomControlsView: View {
    @Binding var streamData: VideoData
    @Binding var showUI: Bool
    @ObservedObject var playerVM: PlayerViewModel
    @Binding var number: Int
    @Binding var animateBackward: Bool
    @Binding var animateForward: Bool
    @State var progress = 0.25
    @State var isLoading: Bool = false
    @State var showEpisodeSelector: Bool = false
    @State var volumeDrag: Bool = false
    @State var showSubs: Bool = true
    
    @State var showingPopup = false
    @State var showingEpisodeSelector = false
    @State var rotation: Double = 0.0
    
    @StateObject var globalData = GlobalData.shared
    
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
    @State var isMacos: Bool = false
    @State var showMacosPopover: Bool = false
    
    @State var showServers: Bool = false
    @State var showSettings: Bool = false
    @State var showMediaList: Bool = false
    @State var selectedMediaItem: Int = 0
    @State var selectedQuality: Int = 0
    
    @State var settingsPage: SettingsPage = .home
    
    @StateObject var Colors = DynamicColors()
    
    @Environment(\.colorScheme) var colorScheme
    
    
    func getSkipPercentage(currentTime: Double, startTime: Double, endTime: Double) -> Double {
        if(startTime <= currentTime && endTime >= currentTime) {
            let timeElapsed = currentTime - startTime
            let totalTime = endTime - startTime
            let percentage = timeElapsed / totalTime
            return percentage
        }
        return 0.0
    }
    
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(showUI ? 0.4 : 0.0)
                
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
                            .frame(width: proxy.size.width / 3, height: proxy.size.height)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture(count: 1)
                                    .onEnded {
                                        showUI = false
                                    }
                                    .sequenced(before: TapGesture(count: 2).onEnded {
                                        Task {
                                            if playerVM.player.currentItem != nil {
                                                await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            }
                                            // add crunchy animation
                                            animateBackward = true
                                            showUI = true
                                            try? await Task.sleep(nanoseconds: 400_000_000)
                                            animateBackward = false
                                            showUI = false
                                        }
                                    })
                            )
                        
                        Color.clear
                            .frame(width: proxy.size.width / 3, height: proxy.size.height)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showUI = false
                            }
                        
                        Color.clear
                            .frame(width: proxy.size.width / 3, height: proxy.size.height)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture(count: 1)
                                    .onEnded {
                                        showUI = false
                                    }
                                    .sequenced(before: TapGesture(count: 2).onEnded {
                                        Task {
                                            if playerVM.player.currentItem != nil {
                                                await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            }
                                            // add crunchy animation
                                            animateForward = true
                                            showUI = true
                                            try? await Task.sleep(nanoseconds: 400_000_000)
                                            animateForward = false
                                            showUI = false
                                        }
                                    })
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
                                
                                
                                Text("Skip \(streamData.skips[0].type)")
                                    .font(.system(size: 14))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .blendMode(BlendMode.difference)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 20)
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
                        .padding(.bottom, 88)
                        .padding(.trailing, 30)
                        .opacity(streamData.skips[0].start <= playerVM.currentTime && streamData.skips[0].end >= playerVM.currentTime ? 1.0 : 0.0)
                    }
                    
                    VStack {
                        // top part
                        HStack {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                ZStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .fixedSize()
                            }
                            
                            Spacer()
                                .frame(maxWidth: 12)
                            
                            
                            if globalData.infoData != nil {
                                VStack {
                                    Text("\(String(globalData.infoData!.mediaList.count > 0 && number < globalData.infoData!.mediaList[0].count ? globalData.infoData!.mediaList[0][number].number : 0)): \(globalData.infoData!.mediaList.count > 0 && number < globalData.infoData!.mediaList[0].count ? (globalData.infoData!.mediaList[0][number].title ?? "") : "")")
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
                            } else {
                                VStack {
                                    Text("1: Episode Title")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Show Title")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 14))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                
                                Text(globalData.newModule?.name ?? "Module Name")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .bold()
                                    .frame(maxWidth: 120, alignment: .trailing)
                                
                                Text(playerVM.getCurrentItem() != nil ? String(Int(playerVM.getCurrentItem()!.presentationSize.width)) + "x" + String(Int(playerVM.getCurrentItem()!.presentationSize.height)) : "Resolution")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: 120, alignment: .trailing)
                            }
                            .frame(maxWidth: 120, alignment: .trailing)
                             
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 12)
                        .zIndex(99)
                        .opacity(animateForward || animateBackward ? 0.0 : 1.0)
                        .animation(.easeInOut, value: animateBackward)
                        .animation(.easeInOut, value: animateForward)
                        
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
                                
                                HStack(spacing: 20) {
                                    Image(systemName: "server.rack")
                                        .fontSize(20)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            Task {
                                                showServers.toggle()
                                            }
                                        }
                                    
                                    Image(systemName: "rectangle.stack.fill")
                                        .fontSize(20)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            Task {
                                                showMediaList.toggle()
                                            }
                                        }
                                    
                                    Image(systemName: "gear")
                                        .fontSize(20)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            Task {
                                                showSettings.toggle()
                                            }
                                        }
                                    
                                    Image(systemName: "forward.fill")
                                        .fontSize(20)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, -4)
                            .opacity(animateForward || animateBackward ? 0.0 : 1.0)
                            .animation(.easeInOut, value: animateBackward)
                            .animation(.easeInOut, value: animateForward)
                            
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
                                    .offset(y: 2)
                                    .opacity(animateBackward ? 0.0 : 1.0)
                                    .animation(.spring(response: 0.3), value: animateBackward)
                                
                                Image(systemName: "gobackward")
                                    .fontSize(28)
                                    .foregroundColor(.white.opacity(1.0))
                                    .rotationEffect(animateBackward ? Angle(degrees: -30) : .zero)
                                    .animation(.spring(response: 0.3), value: animateBackward)
                                    .onTapGesture {
                                        Task {
                                            if playerVM.player.currentItem != nil {
                                                await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            }
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
                            .opacity(animateForward ? 0.0 : 1.0)
                            .animation(.easeInOut, value: animateForward)
                            
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
                                .opacity(animateForward || animateBackward ? 0.0 : 1.0)
                                .animation(.easeInOut, value: animateBackward)
                                .animation(.easeInOut, value: animateForward)
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
                                .opacity(animateForward || animateBackward ? 0.0 : 1.0)
                                .animation(.easeInOut, value: animateBackward)
                                .animation(.easeInOut, value: animateForward)
                                .keyboardShortcut(KeyEquivalent.space, modifiers: [])
                            }
                            
                            Spacer().frame(maxWidth: 72)
                            
                            ZStack {
                                Text("10")
                                    .font(.system(size: 10, weight: .bold))
                                    .offset(y: 2)
                                    .opacity(animateForward ? 0.0 : 1.0)
                                    .animation(.spring(response: 0.3), value: animateForward)
                                
                                Image(systemName: "goforward")
                                    .fontSize(28)
                                    .foregroundColor(.white.opacity(1.0))
                                    .rotationEffect(animateForward ? Angle(degrees: 30) : .zero)
                                    .animation(.spring(response: 0.3), value: animateForward)
                                    .onTapGesture {
                                        Task {
                                            if playerVM.player.currentItem != nil {
                                                await playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            }
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
                            .opacity(animateBackward ? 0.0 : 1.0)
                            .animation(.easeInOut, value: animateBackward)
                            
                            Spacer()
                            
                        }
                        else {
                            ZStack {
                                if(playerVM.hasError == false) {
                                    
                                    ActivityIndicatorView(isVisible: $playerVM.isLoading, type: .growingArc(.white, lineWidth: 4))
                                        .frame(maxWidth: 40, maxHeight: 40)
                                     
                                } else {
                                    HStack {
                                        
                                        ZStack {
                                            Color(hex: "#ffFFE0E4")
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.largeTitle)
                                            .foregroundColor(Color(hex: "#ffDE2627"))
                                            .padding(.bottom, 4)
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
                
                // rectangle.stack.fill for episodes
            }
            .overlay {
                // servers ui
                BottomSheet(isShowing: $showServers, content: AnyView(
                    VStack(spacing: 20) {
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                            
                            Text("Vidstreaming (Sub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                                .opacity(0.0)
                            
                            Text("Vidstreaming (Dub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                                .opacity(0.0)
                            
                            Text("Vidcloud (Sub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                                .opacity(0.0)
                            
                            Text("Vidcloud (Dub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                                .opacity(0.0)
                            
                            Text("Streamtape (Sub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        HStack {
                            Circle()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                                .frame(width: 10)
                                .opacity(0.0)
                            
                            Text("Streamtape (Dub)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .padding(.leading, 60)
                    .padding(.trailing, 16)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .foregroundColor(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              )
                             )
                    )
                    .background {
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.SurfaceContainer.dark
                                : Colors.SurfaceContainer.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.SurfaceContainer.dark
                                : Colors.SurfaceContainer.light
                              )
                        )
                    }
                    
                ), fromLeft: true)
            }
            .overlay {
                // settings ui
                BottomSheet(isShowing: $showSettings, content: AnyView(
                    ZStack {
                        if settingsPage == .home {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "gear")
                                        .fontSize(28)
                                    
                                    Text("Quality")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .fontSize(22)
                                }
                                .onTapGesture {
                                    settingsPage = .quality
                                }
                                
                                HStack {
                                    Image(systemName: "gear")
                                        .fontSize(28)
                                    
                                    Text("Speed")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .fontSize(22)
                                }
                                HStack {
                                    Image(systemName: "gear")
                                        .fontSize(28)
                                    
                                    Text("Video")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .fontSize(22)
                                }
                                HStack {
                                    Image(systemName: "gear")
                                        .fontSize(28)
                                    
                                    Text("Player")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .fontSize(22)
                                }
                            }
                        } else {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .fontSize(22)
                                    
                                    Text("Qualities")
                                    
                                    Spacer()
                                }
                                .onTapGesture {
                                    settingsPage = .home
                                }
                                
                                ForEach(0..<streamData.sources.count) { index in
                                    HStack {
                                        ZStack {
                                            if selectedQuality == index {
                                                Circle()
                                                    .fill(
                                                        Color(hex:
                                                                globalData.appearance == .system
                                                              ? (
                                                                colorScheme == .dark
                                                                ? Colors.Primary.dark
                                                                : Colors.Primary.light
                                                              ) : (
                                                                globalData.appearance == .dark
                                                                ? Colors.Primary.dark
                                                                : Colors.Primary.light
                                                              )
                                                             )
                                                    )
                                                    .frame(width: 12)
                                            }
                                            
                                            Circle()
                                                .stroke(
                                                    selectedQuality == index ?
                                                    Color(hex:
                                                            globalData.appearance == .system
                                                          ? (
                                                            colorScheme == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          ) : (
                                                            globalData.appearance == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          )
                                                         )
                                                    : Color(hex:
                                                                globalData.appearance == .system
                                                              ? (
                                                                colorScheme == .dark
                                                                ? Colors.onSurface.dark
                                                                : Colors.onSurface.light
                                                              ) : (
                                                                globalData.appearance == .dark
                                                                ? Colors.onSurface.dark
                                                                : Colors.onSurface.light
                                                              )
                                                             ), lineWidth: 1
                                                )
                                                .frame(width: 16)
                                        }
                                        
                                        Text(streamData.sources[index].quality)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                    }
                                    .onTapGesture {
                                        selectedQuality = index
                                        
                                        // store current time
                                        let temp = playerVM.currentTime
                                        
                                        // set media item to new source
                                        playerVM.setCurrentItem(AVPlayerItem(url: URL(string: streamData.sources[index].file)!))
                                        playerVM.isEditingCurrentTime = true
                                        playerVM.currentTime = temp
                                        playerVM.isEditingCurrentTime = false
                                        
                                        playerVM.player.play()
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .padding(.top, 16)
                    .frame(maxWidth: 440, maxHeight: 256)
                    .foregroundColor(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              )
                             )
                    )
                    .background {
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.SurfaceContainer.dark
                                : Colors.SurfaceContainer.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.SurfaceContainer.dark
                                : Colors.SurfaceContainer.light
                              )
                        )
                    }
                ))
            }
            .overlay {
                // medialist ui
                BottomSheet(isShowing: $showMediaList, content: AnyView(
                    VStack(spacing: 20) {
                        ScrollView {
                            VStack {
                                ForEach(startEpisodeList..<min(endEpisodeList, globalData.infoData!.mediaList[0].count), id: \.self) { index in
                                    ZStack(alignment: .top) {
                                        Color(hex:
                                                globalData.appearance == .system
                                              ? (
                                                colorScheme == .dark
                                                ? Colors.SurfaceContainer.dark
                                                : Colors.SurfaceContainer.light
                                              ) : (
                                                globalData.appearance == .dark
                                                ? Colors.SurfaceContainer.dark
                                                : Colors.SurfaceContainer.light
                                              )
                                        )
                                        
                                        VStack(spacing: 0) {
                                            HStack(spacing: 8) {
                                                KFImage(URL(string: globalData.infoData!.mediaList[0][index].image ?? globalData.infoData!.poster))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(maxWidth: 150, maxHeight: 90)
                                                    .cornerRadius(12)
                                                
                                                VStack(alignment: .leading) {
                                                    Spacer()
                                                    
                                                    HStack {
                                                        Text(globalData.infoData!.mediaList[0][index].title ?? "Episode \(globalData.infoData!.mediaList[0][index].number)")
                                                            .font(.subheadline)
                                                            .fontWeight(.semibold)
                                                            .lineLimit(2)
                                                            .multilineTextAlignment(.leading)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    Spacer()
                                                    
                                                    HStack {
                                                        Text("Episode \(forTrailingZero(temp: globalData.infoData!.mediaList[0][index].number))")
                                                            .font(.caption)
                                                            .fontWeight(.semibold)
                                                        
                                                        Spacer()
                                                        
                                                        Text("24 mins")
                                                            .font(.caption)
                                                            .fontWeight(.semibold)
                                                    }
                                                    .opacity(0.7)
                                                    .padding(.bottom, 6)
                                                }
                                                .padding(.trailing, 8)
                                                .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                            }
                                            if globalData.infoData!.mediaList[0][index].description != nil {
                                                Text(globalData.infoData!.mediaList[0][index].description!)
                                                    .font(.caption)
                                                    .lineLimit(4)
                                                    .opacity(0.7)
                                                    .padding(12)
                                            }
                                        }
                                    }
                                    .cornerRadius(12)
                                    .foregroundColor(Color(hex:
                                                            globalData.appearance == .system
                                                           ? (
                                                            colorScheme == .dark
                                                            ? Colors.onSurface.dark
                                                            : Colors.onSurface.light
                                                           ) : (
                                                            globalData.appearance == .dark
                                                            ? Colors.onSurface.dark
                                                            : Colors.onSurface.light
                                                           )
                                                          ))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedMediaItem = index
                                            
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 64)
                        }
                        .padding(20)
                        .padding(.leading, 16)
                        .overlay(alignment: .bottom) {
                            ZStack {
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.SurfaceContainer.dark
                                        : Colors.SurfaceContainer.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.SurfaceContainer.dark
                                        : Colors.SurfaceContainer.light
                                      )
                                )
                                
                                if(globalData.infoData!.mediaList.count > 0 && globalData.infoData!.mediaList[0].count > 50) {
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 20) {
                                            ForEach(0..<Int(ceil(Float(globalData.infoData!.mediaList[0].count)/50))) { index in
                                                PaginationChip(paginationIndex: $paginationIndex, startEpisodeList: $startEpisodeList, endEpisodeList: $endEpisodeList, episodeCount: globalData.infoData!.mediaList[0].count, index: index, Colors: Colors, small: true)
                                            }
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        }
                    }
                    .frame(maxWidth: 350, maxHeight: .infinity)
                    .foregroundColor(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              )
                             )
                    )
                    .background {
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.Surface.dark
                                : Colors.Surface.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.Surface.dark
                                : Colors.Surface.light
                              )
                        )
                    }
                    
                ), fromRight: true)
            }
            .onAppear {
                isMacos = proxy.size.width > 900
                print("Source: \(streamData.sources[0].file)")
            }
        }
        
    }
}

struct CustomControlsViewPreviewBridge: View {
    @StateObject var playerVM = PlayerViewModel()
    @State var showUI = true
    
    var body: some View {
        CustomControlsView(streamData: .constant(VideoData(sources: [
            Source(file: "https://c-an-ca4.betterstream.cc:2223/hls-playback/6bad66e945c851b0ce0cda2d993bd6ab0f177e531d132d4b68d66ba95f6fbabf0193efeb286abd5cef6b6344c610b3df67e9e3fdbad7faa8fec72d9aa1d253dbf51a48f8f7f1fad161ef18f18104a2ceff11ff9fec071992db22522567cac5cec8686b8810cfc02819df1c51fd6b24c1201de7497d845a5cde09a25a0da02e0d5ecc73e577a68553f79136cab7785906/index-f1-v1-a1.m3u8", type: "hls", quality: "auto")
        ], subtitles: [], skips: [
            SkipTime(start: 0.0, end: 100.0, type: "Opening")
        ])), showUI: $showUI, playerVM: playerVM, number: .constant(1), animateBackward: .constant(false), animateForward: .constant(false))
        .onAppear {
            playerVM.isLoading = false
        }
    }
}

struct CustomControlsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomControlsViewPreviewBridge()
    }
}
