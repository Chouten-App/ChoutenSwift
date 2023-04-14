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

struct Servers: Codable {
    let name: String
    let url: String
}

struct VideoData: Codable {
    let sources: [Source]
    let subtitles: [Subtitle]
}

struct Subtitle: Codable {
    let url: String
    let language: String
}

struct Source: Codable {
    let file: String
    let type: String
}

#if os(iOS)
struct WebView: UIViewRepresentable {
    @State var htmlString: String
    let javaScript: String
    let requestType: String
    let enableExternalScripts: Bool
    @StateObject var globalData: GlobalData
    @Binding var nextUrl: String
    @Binding var mediaConsumeData: VideoData
    
    func makeUIView(context: Context) -> WKWebView {
        print("MAKING NEW WEBVIEW")
        print(javaScript)
        
        let consoleScript = WKUserScript(source: "console.log = function(log) { window.webkit.messageHandlers.console.postMessage(log); }", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let divCreationString = """
            let choutenDivElement = document.createElement('div');
            choutenDivElement.setAttribute('id', 'chouten');
            document.body.prepend(choutenDivElement);
            """
        
        let divCreation = WKUserScript(source: divCreationString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(divCreation)
        userContentController.addUserScript(consoleScript)
        
        let scriptHandlerString = """
            window.webkit.messageHandlers.callbackHandler.postMessage(document.getElementById('chouten').innerText);
            """
        
        let jsInject = WKUserScript(source: javaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(jsInject)
        
        let scriptHandler = WKUserScript(source: scriptHandlerString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(scriptHandler)
        
        let handlerName = "callbackHandler"
        userContentController.add(context.coordinator, name: handlerName)
        
        
        class ConsoleMessageHandler: NSObject, WKScriptMessageHandler {
            func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
                if message.name == "console", let messageBody = message.body as? String {
                    print("Console log: \(messageBody)")
                }
            }
        }

        let consoleMessageHandler = ConsoleMessageHandler()
        userContentController.add(consoleMessageHandler, name: "console")
        
        
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = enableExternalScripts // Enable JavaScript
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(javaScript: javaScript, requestType: requestType,globalData: globalData, nextUrl: $nextUrl, mediaConsumeData: $mediaConsumeData)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        let requestType: String
        var globalData: GlobalData
        @Binding var nextUrl: String
        @Binding var mediaConsumeData: VideoData
        
        init(javaScript: String, requestType: String, globalData: GlobalData, nextUrl: Binding<String>, mediaConsumeData: Binding<VideoData>) {
            self.javaScript = javaScript
            self.requestType = requestType
            self.globalData = globalData
            self._nextUrl = nextUrl
            self._mediaConsumeData = mediaConsumeData
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler" {
                
                print("Received message from web view: \(message.body)")
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
                        } else if requestType == "info" {
                            do {
                                let info = try decoder.decode(DecodableResult<InfoData>.self, from: data!)
                                globalData.infoData = info.result
                                globalData.nextUrl = info.nextUrl
                                globalData.doneInfo = true
                                print(info)
                            } catch {
                                print(error.localizedDescription)
                            }
                            print("trying next")
                            do {
                                let info = try decoder.decode(DecodableResult<String>.self, from: data!)
                                print(info)
                                globalData.nextUrl = info.nextUrl ?? ""
                                globalData.doneInfo = false
                            } catch {
                                print(error.localizedDescription)
                            }
                            print("trying next")
                            do {
                                let info = try decoder.decode([MediaItem].self, from: data!)
                                print(info)
                                globalData.infoData?.mediaList[0] = info
                                globalData.doneInfo = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else if requestType == "mediaServers" {
                            do {
                                let info = try decoder.decode(DecodableResult<[Servers]>.self, from: data!)
                                print(info)
                                nextUrl = info.nextUrl ?? ""
                            } catch {
                                print(error.localizedDescription)
                                do {
                                    let info = try decoder.decode(DecodableResult<VideoData>.self, from: data!)
                                    print(info)
                                    mediaConsumeData = info.result
                                    nextUrl = info.nextUrl ?? ""
                                } catch {
                                    print(error.localizedDescription)
                                }
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
#elseif os(macOS)

struct WebView: NSViewRepresentable {
    let htmlString: String
    let javaScript: String
    let requestType: String
    @StateObject var globalData: GlobalData
    
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
        Coordinator(javaScript: javaScript, requestType: requestType, globalData: globalData)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        let requestType: String
        var globalData: GlobalData
        
        init(javaScript: String, requestType: String, globalData: GlobalData) {
            self.javaScript = javaScript
            self.requestType = requestType
            self.globalData = globalData
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler" {
                
                print("Received message from web view: \(message.body)")
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
        WebView(htmlString: "", javaScript: "", requestType: "", enableExternalScripts: false, globalData: GlobalData(), nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [])))
    }
}
