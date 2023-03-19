//
//  WebView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlString: String
    let javaScript: String
    @StateObject var globalData: GlobalData
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let handlerName = "callbackHandler"
        let scriptHandler = context.coordinator
        configuration.userContentController.add(scriptHandler, name: handlerName)
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
            if let messageBody = message.body as? String {
                            print("Received message from web view: \(messageBody)")
                        } else {
                            print("Received message from web view: \(message.body)")
                        }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(javaScript) { result, error in
                if let error = error {
                    print("Error executing JavaScript: \(error.localizedDescription)")
                } else if let result = result {
                    print("JavaScript result: \(result)")
                    let jsonData = Data((result as? String ?? "").utf8)
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(InfoData.self, from: jsonData)
                        self.globalData.moduleData = decodedData
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                    self.globalData.moduleText = result as? String ?? ""
                } else {
                    print("JavaScript executed successfully")
                }
            }
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(htmlString: "", javaScript: "", globalData: GlobalData())
    }
}
