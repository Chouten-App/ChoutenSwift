#if os(iOS)
import UIKit
import SwiftUI

extension Notification.Name {
    static let sharedJson = Notification.Name("com.applemusic.shared.json")
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
                    Home()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("working")
        if let urlContext = URLContexts.first {
            handleOpenURL(urlContext.url)
        }
    }

    func handleOpenURL(_ url: URL) {
        print(url)
        NotificationCenter.default.post(name: .sharedJson, object: nil, userInfo: ["url": url])
    }
    
    @objc func handleSharedJson(_ notification: Notification) {
        guard notification.userInfo?["url"] is URL else { return }
        
        if let shouldOpenApp = notification.userInfo?["openApp"] as? Bool, shouldOpenApp {
            // Open the app
            if let window = self.window {
                let hostingController = HostingController(
                    wrappedView:
                        Home()
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                )
                window.rootViewController = hostingController
                window.makeKeyAndVisible()
            }
        }
        
        // Handle the JSON data
        // ...
    }
}
#endif

