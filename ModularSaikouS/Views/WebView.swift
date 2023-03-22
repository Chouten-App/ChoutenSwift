//
//  WebView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import WebKit
#if os(iOS)
struct WebView: UIViewRepresentable {
    let htmlString: String
    let javaScript: String
    @StateObject var globalData: GlobalData
    
    func makeUIView(context: Context) -> WKWebView {
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
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the web view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(javaScript: javaScript, globalData: globalData)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        var globalData: GlobalData
        
        init(javaScript: String, globalData: GlobalData) {
            self.javaScript = javaScript
            self.globalData = globalData
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler" {
                
                print("Received message from web view: \(message.body)")
                if let message = message.body as? String {
                    let data = message.data(using: .utf8)
                    let decoder = JSONDecoder()

                    if data != nil {
                        do {
                            let searchResults = try decoder.decode([InfoData].self, from: data!)
                            globalData.searchResults = searchResults
                        } catch {
                            print(error.localizedDescription)
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
        Coordinator(javaScript: javaScript, globalData: globalData)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let javaScript: String
        var globalData: GlobalData
        
        init(javaScript: String, globalData: GlobalData) {
            self.javaScript = javaScript
            self.globalData = globalData
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler" {
                
                print("Received message from web view: \(message.body)")
                if let message = message.body as? String {
                    let data = message.data(using: .utf8)
                    let decoder = JSONDecoder()

                    if data != nil {
                        do {
                            let searchResults = try decoder.decode([InfoData].self, from: data!)
                            globalData.searchResults = searchResults
                        } catch {
                            print(error.localizedDescription)
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
        WebView(htmlString: "", javaScript: "", globalData: GlobalData())
    }
}
