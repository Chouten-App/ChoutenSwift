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
    let number: Int
    @State var htmlString = ""
    @State var jsString = ""
    @State var nextUrl: String = ""
    @State var mediaConsumeData: VideoData = VideoData(sources: [], subtitles: [], skips: [])
    @State var mediaSubtitleLink: String = ""
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @State var returnData: ReturnedData? = nil
    
    @State var currentJsIndex = 0
    
    private var isIOS16: Bool {
        guard #available(iOS 16, *) else {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            CustomPlayerWithControls(streamData: $mediaConsumeData, number: number)
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
            if htmlString.count > 0 && returnData != nil {
                WebView(htmlString: htmlString, javaScript: jsString, requestType: "mediaServers", enableExternalScripts: returnData!.allowExternalScripts, nextUrl: $nextUrl, mediaConsumeData: $mediaConsumeData, mediaConsumeBookData: .constant([]))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .onAppear {
            print(self.url)
            if mediaConsumeData.sources.count > 0 {
                return
            }
            htmlString = ""
            if globalData.newModule != nil {
                htmlString = ""
                
                // get search js file data
                if returnData == nil {
                    returnData = moduleManager.getJsForType("media", num: currentJsIndex)
                    jsString = returnData!.js
                }
                if returnData != nil {
                    Task {
                        if returnData!.request != nil {
                            let (data, response) = try await URLSession.shared.data(from: URL(string: returnData!.request!.url)!)
                            do {
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    let data = ["data": FloatyData(message: "Failed to load data from \(returnData!.request!.url)", error: true, action: nil)]
                                    NotificationCenter.default
                                        .post(name:           NSNotification.Name("floaty"),
                                              object: nil, userInfo: data)
                                    return
                                }
                                if returnData!.usesApi {
                                    let regexPattern = "&#\\d+;"
                                    let regex = try! NSRegularExpression(pattern: regexPattern)
                                    
                                    let range = NSRange(html.startIndex..., in: html)
                                    
                                    let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                    
                                    let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                } else {
                                    htmlString = html
                                }
                            } catch let error {
                                print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                            }
                        } else {
                            let (data, response) = try await URLSession.shared.data(from: URL(string: self.url)!)
                            do {
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    let data = ["data": FloatyData(message: "Failed to load data from \(self.url)", error: true, action: nil)]
                                    NotificationCenter.default
                                        .post(name:           NSNotification.Name("floaty"),
                                              object: nil, userInfo: data)
                                    return
                                }
                                if returnData!.usesApi {
                                    let regexPattern = "&#\\d+;"
                                    let regex = try! NSRegularExpression(pattern: regexPattern)
                                    
                                    let range = NSRange(html.startIndex..., in: html)
                                    
                                    let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                    
                                    let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                } else {
                                    htmlString = html
                                }
                            } catch let error {
                                print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                            }
                        }
                        
                    }
                }
            }
        }
        .onChange(of: nextUrl) { _ in
            if mediaConsumeData.sources.count > 0 {
                return
            }
            if nextUrl.count > 0 {
                htmlString = ""
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if globalData.newModule != nil {
                            if currentJsIndex < moduleManager.getJsCount("media") {
                                if currentJsIndex == 0 {
                                    currentJsIndex = 2
                                } else {
                                    currentJsIndex += 1
                                }
                            }
                            // get search js file data
                            returnData = moduleManager.getJsForType("media", num: currentJsIndex)
                            print("Current JS File: \(currentJsIndex)")
                            
                            if returnData != nil {
                                jsString = returnData!.js
                                Task {
                                    if returnData!.request != nil {
                                        let (data, response) = try await URLSession.shared.data(from: URL(string: returnData!.request!.url)!)
                                        do {
                                            guard let httpResponse = response as? HTTPURLResponse,
                                                  httpResponse.statusCode == 200,
                                                  let html = String(data: data, encoding: .utf8) else {
                                                let data = ["data": FloatyData(message: "Failed to load data from \(returnData!.request!.url)", error: true, action: nil)]
                                                NotificationCenter.default
                                                    .post(name:           NSNotification.Name("floaty"),
                                                          object: nil, userInfo: data)
                                                return
                                            }
                                            if returnData!.usesApi {
                                                let regexPattern = "&#\\d+;"
                                                let regex = try! NSRegularExpression(pattern: regexPattern)
                                                
                                                let range = NSRange(html.startIndex..., in: html)
                                                
                                                let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                                
                                                let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                                if returnData!.imports.isNotEmpty {
                                                    var scripts = ""
                                                    
                                                    for imp in returnData!.imports {
                                                        scripts.append("<script src=\"\(imp)\"></script>")
                                                    }
                                                    
                                                    htmlString = """
                                                    <!DOCTYPE html>
                                                      <html>
                                                        <head>
                                                          <title>My Web Page</title>
                                                          \(scripts)
                                                        </head>
                                                        <body>
                                                            <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                                                        </body>
                                                      </html>
                                                    """
                                                } else {
                                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                                }
                                            } else {
                                                htmlString = html
                                            }
                                        } catch let error {
                                            print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                        }
                                    } else {
                                        let (data, response) = try await URLSession.shared.data(from: URL(string: nextUrl)!)
                                        do {
                                            guard let httpResponse = response as? HTTPURLResponse,
                                                  httpResponse.statusCode == 200,
                                                  let html = String(data: data, encoding: .utf8) else {
                                                let data = ["data": FloatyData(message: "Failed to load data from \(nextUrl)", error: true, action: nil)]
                                                NotificationCenter.default
                                                    .post(name:           NSNotification.Name("floaty"),
                                                          object: nil, userInfo: data)
                                                return
                                            }
                                            if returnData!.usesApi {
                                                let regexPattern = "&#\\d+;"
                                                let regex = try! NSRegularExpression(pattern: regexPattern)
                                                
                                                let range = NSRange(html.startIndex..., in: html)
                                                
                                                let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                                
                                                let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                                if returnData!.imports.isNotEmpty {
                                                    var scripts = ""
                                                    
                                                    for imp in returnData!.imports {
                                                        scripts.append("<script src=\"\(imp)\"></script>")
                                                    }
                                                    
                                                    htmlString = """
                                                    <!DOCTYPE html>
                                                      <html>
                                                        <head>
                                                          <title>My Web Page</title>
                                                          \(scripts)
                                                        </head>
                                                        <body>
                                                            <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                                                        </body>
                                                      </html>
                                                    """
                                                } else {
                                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                                }
                                            } else {
                                                htmlString = html
                                            }
                                        } catch let error {
                                            print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                        }
                                    }
                                    
                                }
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
        WatchPage(url: "", number: 1)
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
                    .foregroundColor(Color("a1-300"))
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
                            // TODO: - maybe use other logic here
                            self.percentage = Float(min(max(0, Double(value.location.y / geometry.size.height * total)), total))
                            playerVM.setVolume(newVolume: self.percentage)
                            
                        })).animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}
