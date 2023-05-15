//
//  WebView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import WebKit

struct DecodableResult<T: Codable>: Codable {
    let result: T
    let nextUrl: String?
}

struct Server: Codable {
    let name: String
    let url: String
}

struct VideoData: Codable {
    let sources: [Source]
    let subtitles: [Subtitle]
    let skips: [SkipTime]
}

struct SkipTime: Codable {
    let start: Double
    let end: Double
    let type: String
}

struct Subtitle: Codable {
    let url: String
    let language: String
}

struct Source: Codable {
    let file: String
    let type: String
    let quality: String
}

#if os(iOS)
struct WebView: UIViewRepresentable {
    @State var htmlString: String
    let javaScript: String
    let requestType: String
    let enableExternalScripts: Bool
    @Binding var nextUrl: String
    @Binding var mediaConsumeData: VideoData
    @Binding var mediaConsumeBookData: [String]
    @StateObject var globalData = GlobalData.shared
    
    func makeUIView(context: Context) -> WKWebView {
        let divCreationString = """
            let choutenDivElement = document.createElement('div');
            choutenDivElement.setAttribute('id', 'chouten');
            document.body.prepend(choutenDivElement);
            """
        
        let divCreation = WKUserScript(source: divCreationString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(divCreation)
        
        let jsInject = WKUserScript(source: javaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        userContentController.addUserScript(jsInject)
        
        let scriptHandlerString = """
            window.webkit.messageHandlers.callbackHandler.postMessage(document.getElementById('chouten').innerText);
            """
        
        let scriptHandler = WKUserScript(source: scriptHandlerString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(scriptHandler)
        
        
        
        let handlerName = "callbackHandler"
        userContentController.add(context.coordinator, name: handlerName)
        userContentController.add(context.coordinator, name: "jsErrorHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let preferences = WKWebpagePreferences()
        
        preferences.allowsContentJavaScript = true // Enable JavaScript
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(javaScript: javaScript, requestType: requestType, nextUrl: $nextUrl, mediaConsumeData: $mediaConsumeData, mediaConsumeBookData: $mediaConsumeBookData)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        let requestType: String
        @Binding var nextUrl: String
        @Binding var mediaConsumeData: VideoData
        @Binding var mediaConsumeBookData: [String]
        @StateObject var globalData = GlobalData.shared
        
        init(javaScript: String, requestType: String, nextUrl: Binding<String>, mediaConsumeData: Binding<VideoData>, mediaConsumeBookData: Binding<[String]>) {
            self.javaScript = javaScript
            self.requestType = requestType
            self._nextUrl = nextUrl
            self._mediaConsumeData = mediaConsumeData
            self._mediaConsumeBookData = mediaConsumeBookData
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("WEBKIT: \(message.body)")
            if message.name == "callbackHandler" {
                if let message = message.body as? String {
                    let data = message.data(using: .utf8)
                    let decoder = JSONDecoder()

                    if data != nil {
                        if requestType == "home" {
                            do {
                                let homeComponents = try decoder.decode(DecodableResult<[HomeComponent]>.self, from: data!)
                                globalData.homeComponents = homeComponents.result
                                globalData.isLoadingHomepage = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else if requestType == "search" {
                            do {
                                let searchResults = try decoder.decode([SearchData].self, from: data!)
                                globalData.searchResults = searchResults
                                globalData.isLoading = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else if requestType == "info" {
                            do {
                                let info = try decoder.decode(DecodableResult<InfoData>.self, from: data!)
                                if globalData.infoData == nil {
                                    globalData.infoData = info.result
                                } else {
                                    globalData.infoData!.mediaList = info.result.mediaList
                                }
                                globalData.nextUrl = info.nextUrl ?? ""
                                globalData.doneInfo = true
                                return
                            } catch {
                                print(error.localizedDescription)
                            }
                            do {
                                let info = try decoder.decode(DecodableResult<String>.self, from: data!)
                                globalData.nextUrl = info.nextUrl ?? ""
                                globalData.doneInfo = false
                                return
                            } catch {
                                print(error.localizedDescription)
                            }
                            do {
                                let info = try decoder.decode([MediaItem].self, from: data!)
                                globalData.infoData?.mediaList[0] = info
                                globalData.doneInfo = false
                                globalData.mediaFailedToLoad = false
                                return
                            } catch {
                                print(error.localizedDescription)
                                globalData.mediaFailedToLoad = true
                            }
                        } else if requestType == "mediaServers" {
                            do {
                                let info = try decoder.decode(DecodableResult<[Server]>.self, from: data!)
                                nextUrl = info.nextUrl ?? ""
                                return
                            } catch {
                                print(error.localizedDescription)
                            }
                            do {
                                let info = try decoder.decode(DecodableResult<VideoData>.self, from: data!)
                                mediaConsumeData = info.result
                                nextUrl = info.nextUrl ?? ""
                                return
                            } catch {
                                print(error.localizedDescription)
                            }
                            do {
                                let info = try decoder.decode(DecodableResult<[String]>.self, from: data!)
                                mediaConsumeBookData = info.result
                                nextUrl = info.nextUrl ?? ""
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            } else if message.name == "jsErrorHandler" {
                let error = (message.body as? [String: Any])?["message"] as? String ?? "unknown"
                print("JavaScript error occurred: \(error)")
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
        }
    }
}
#elseif os(macOS)

struct WebView: NSViewRepresentable {
    let htmlString: String
    let javaScript: String
    let requestType: String
    @StateObject var globalData = GlobalData.shared
    
    func makeNSView(context: Context) -> WKWebView {
        let divCreationString = """
            let choutenDivElement = document.createElement('div');
            choutenDivElement.setAttribute('id', 'chouten');
            document.body.prepend(choutenDivElement);
            """
        
        let divCreation = WKUserScript(source: divCreationString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(divCreation)
        
        let scriptHandlerString = """
            window.webkit.messageHandlers.callbackHandler.postMessage(document.getElementById('chouten').innerText);
            """
        
        let jsInject = WKUserScript(source: javaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(jsInject)
        
        let scriptHandler = WKUserScript(source: scriptHandlerString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(scriptHandler)
        
        let handlerName = "callbackHandler"
        userContentController.add(context.coordinator, name: handlerName)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // No need to update the web view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(javaScript: javaScript, requestType: requestType)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        let requestType: String
        @StateObject var globalData = GlobalData.shared
        
        init(javaScript: String, requestType: String) {
            self.javaScript = javaScript
            self.requestType = requestType
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler" {
                if let message = message.body as? String {
                    let data = message.data(using: .utf8)
                    let decoder = JSONDecoder()

                    if data != nil {
                        if requestType == "search" {
                            do {
                                let searchResults = try decoder.decode([SearchData].self, from: data!)
                                globalData.searchResults = searchResults
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
        }
    }
}
#endif

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(htmlString: "", javaScript: "", requestType: "", enableExternalScripts: false, nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [], skips: [])), mediaConsumeBookData: .constant([]))
    }
}
