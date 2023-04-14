//
//  WatchTemp.swift
//  ModularSaikouS
//
//  Created by Inumaki on 10.04.23.
//

import SwiftUI

struct WatchTemp: View {
    let url: String
    @StateObject var globalData: GlobalData
    @State var htmlString = ""
    @State var nextUrl: String = ""
    @State var mediaConsumeLink: String = ""
    
    @State var currentJsIndex = 0
    
    var body: some View {
        VStack {
            Text(url)
            Text(mediaConsumeLink)
        }
        .background {
            if htmlString.count > 0 {
                WebView(htmlString: htmlString, javaScript: globalData.module!.code["anime"]!["mediaConsume"]![currentJsIndex].javascript.code, requestType: "mediaServers", enableExternalScripts: globalData.module!.code["anime"]!["mediaConsume"]![currentJsIndex].javascript.allowExternalScripts, globalData: globalData, nextUrl: $nextUrl, mediaConsumeData: .constant(VideoData(sources: [], subtitles: [])))
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

struct WatchTemp_Previews: PreviewProvider {
    static var previews: some View {
        WatchTemp(url: "", globalData: GlobalData())
        
    }
}
