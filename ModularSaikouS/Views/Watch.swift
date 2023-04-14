//
//  WatchPage.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//
import SwiftUI
import AVKit
import SwiftUIFontIcon

import Combine
import SwiftWebVTT
import ActivityIndicatorView

extension Bool {
     static var iOS16: Bool {
         guard #available(iOS 16, *) else {
             // It's iOS 13 so return true.
             return true
         }
         // It's iOS 14 so return false.
         return false
     }
 }

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .trailing))}
}


struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.white
    var strokeWidth = 12.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct WatchPage: View {
    let url: String
    @StateObject var globalData: GlobalData
    @State var htmlString = ""
    @State var nextUrl: String = ""
    @State var mediaConsumeData: VideoData = VideoData(sources: [], subtitles: [])
    @State var mediaSubtitleLink: String = ""
    
    @State var currentJsIndex = 0
    
    @Environment(\.presentationMode) var presentation
    @State private var isPresented = false
    
    private var isIOS16: Bool {
        guard #available(iOS 16, *) else {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            CustomPlayerWithControls(streamData: $mediaConsumeData)
                .navigationBarBackButtonHidden(true)
                .contentShape(Rectangle())
                .ignoresSafeArea(.all)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .supportedOrientation(.landscape)
        .if(isIOS16) {view in
            view.prefersHomeIndicatorAutoHidden(true)
        }
        .background {
            if htmlString.count > 0 {
                WebView(htmlString: htmlString, javaScript: globalData.module!.code["anime"]!["mediaConsume"]![currentJsIndex].javascript.code, requestType: "mediaServers", enableExternalScripts: globalData.module!.code["anime"]!["mediaConsume"]![currentJsIndex].javascript.allowExternalScripts, globalData: globalData, nextUrl: $nextUrl, mediaConsumeData: $mediaConsumeData)
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .onAppear {
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200,
                          let html = String(data: data, encoding: .utf8) else {
                        print("Invalid response")
                        return
                    }
                    
                    htmlString = "<div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>"
                    
                    print(htmlString)
                } catch let error {
                    print(error)
                }
            }
            
        }
        .onChange(of: nextUrl) { _ in
            if nextUrl.count > 0 {
                htmlString = ""
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Task {
                            do {
                                let (data, response) = try await URLSession.shared.data(from: URL(string: nextUrl)!)
                                
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    print("Invalid response")
                                    return
                                }
                                htmlString = """
                                <!DOCTYPE html>
                                  <html>
                                    <head>
                                      <title>My Web Page</title>
                                      <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
                                    </head>
                                    <body>
                                                                      <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                                    </body>
                                  </html>
                                """
                                currentJsIndex += 1
                                print(htmlString)
                            } catch let error {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct WatchPage_Previews: PreviewProvider {
    static var previews: some View {
        WatchPage(url: "", globalData: GlobalData())
    }
}

struct CustomView: View {
    
    @Binding var percentage: Double // or some value binded
    @Binding var buffered: Double
    @Binding var isDragging: Bool
    var total: Double
    @Binding var isMacos: Bool
    @State var barHeight: CGFloat = 6
    
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .bottomLeading) {
                
                Rectangle()
                    .foregroundColor(.white.opacity(0.4)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                Rectangle()
                    .foregroundColor(.white.opacity(0.4))
                    .frame(width: geometry.size.width * CGFloat(self.buffered / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                Rectangle()
                    .foregroundColor(Color("accentColor1"))
                    .frame(width: geometry.size.width * CGFloat(self.percentage / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
            }.frame(maxHeight: .infinity, alignment: .center)
                .cornerRadius(12)
                .overlay {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded({ value in
                                self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                                self.isDragging = false
                                self.barHeight = isMacos ? 12 : 6
                            })
                            .onChanged({ value in
                                    self.isDragging = true
                                    self.barHeight = isMacos ? 18 : 10
                                    print(value)
                                    // TODO: - maybe use other logic here
                                    self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                                })
                        )
                }
                .animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}

struct VolumeView: View {
    
    @State var percentage: Float // or some value binded
    @Binding var isDragging: Bool
    @State var barWidth: CGFloat = 6
    @State var playerVM: PlayerViewModel
    
    var total: Double
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .bottomLeading) {
                
                Rectangle()
                    .foregroundColor(.white.opacity(0.5)).frame(width: barWidth, alignment: .bottom).cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onEnded({ value in
                            self.percentage = Float(min(max(0, Double(value.location.y / geometry.size.height * total)), total))
                            self.isDragging = false
                            self.barWidth = 6
                            
                            playerVM.setVolume(newVolume: self.percentage)
                            
                        })
                            .onChanged({ value in
                                self.isDragging = true
                                self.barWidth = 10
                                print(value)
                                // TODO: - maybe use other logic here
                                self.percentage = Float(min(max(0, Double(value.location.y / geometry.size.height * total)), total))
                                
                                playerVM.setVolume(newVolume: self.percentage)
                                
                            })).animation(.spring(response: 0.3), value: self.isDragging)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: geometry.size.height * CGFloat(Double(self.percentage) / total)).frame(width: barWidth, alignment: .bottom).cornerRadius(12)
                
                
            }.frame(maxHeight: .infinity, alignment: .center)
                .cornerRadius(12)
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded({ value in
                        self.percentage = Float(min(max(0, Double(value.location.y / geometry.size.height * total)), total))
                        self.isDragging = false
                        self.barWidth = 6
                        
                        playerVM.setVolume(newVolume: self.percentage)
                        
                    })
                        .onChanged({ value in
                            self.isDragging = true
                            self.barWidth = 10
                            print(value)
                            // TODO: - maybe use other logic here
                            self.percentage = Float(min(max(0, Double(value.location.y / geometry.size.height * total)), total))
                            playerVM.setVolume(newVolume: self.percentage)
                            
                        })).animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}
