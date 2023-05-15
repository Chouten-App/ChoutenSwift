#if os(iOS)
import UIKit
import SwiftUI

extension Notification.Name {
    static let sharedJson = Notification.Name("com.inumaki.chouten.module")
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let dataController = DataController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSharedJson(_:)), name: .sharedJson, object: nil)

        
        if let urlContext = connectionOptions.urlContexts.first {
            handleOpenURL(urlContext.url)
        }
        
            
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = HostingController(
                wrappedView:
                    OpeningView()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url, url.isFileURL else {
                return
            }

            if url.pathExtension == "module" {
                // Handle the file here
                // For example, you could use FileManager to copy the file to your app's documents directory:
                let fileManager = FileManager.default
                do {
                    let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let destinationURL = documentsURL.appendingPathComponent("Modules").appendingPathComponent(url.lastPathComponent)
                    try fileManager.copyItem(at: url, to: destinationURL)
                    // handle unzip of module
                    
                    ModuleManager.shared.importFromFile(fileUrl: destinationURL)
                    
                } catch {
                    print("Error: \(error)")
                }
            } else if url.pathExtension == "theme" {
                // Handle the file here
                // For example, you could use FileManager to copy the file to your app's documents directory:
                let fileManager = FileManager.default
                do {
                    let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let destinationURL = documentsURL.appendingPathComponent("Themes").appendingPathComponent(url.lastPathComponent)
                    try fileManager.copyItem(at: url, to: destinationURL)
                } catch {
                    print("Error: \(error)")
                }
            }
    }

    func handleOpenURL(_ url: URL) {
        NotificationCenter.default.post(name: .sharedJson, object: nil, userInfo: ["url": url])
    }
    
    @objc func handleSharedJson(_ notification: Notification) {
        guard notification.userInfo?["url"] is URL else { return }
        if let shouldOpenApp = notification.userInfo?["openApp"] as? Bool, shouldOpenApp {
            // Open the app
            if let window = self.window {
                let hostingController = HostingController(
                    wrappedView:
                        OpeningView()
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                )
                window.rootViewController = hostingController
                window.makeKeyAndVisible()
            }
        }
    }
}
#endif

