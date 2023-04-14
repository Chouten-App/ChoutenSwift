//
//  SceneDelegate.swift
//  Anime Now! (iOS)
//
//  Created by Erik Bautista on 10/9/22.
//
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
        if let urlContext = connectionOptions.urlContexts.first {
                handleOpenURL(urlContext.url)
            }
        
            
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = HostingController(
                wrappedView:
                    Search()
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
}
#endif

