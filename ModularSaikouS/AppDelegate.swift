#if os(iOS)
import UIKit
import UniformTypeIdentifiers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent("Themes").appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        
        let fileExists = (try? destURL.checkResourceIsReachable()) ?? false
        if fileExists { return }
        
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
        else {
            print("Source File not found.")
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(at: sourceURL, to: destURL)
        } catch {
            print("Unable to copy file")
        }
    }
    
    func createModuleAndThemesFoldersIfNeeded() {
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let modulesURL = documentsURL.appendingPathComponent("Modules", isDirectory: true)
        let themesURL = documentsURL.appendingPathComponent("Themes", isDirectory: true)

        var isDirectory: ObjCBool = false

        if !fileManager.fileExists(atPath: modulesURL.path, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: modulesURL, withIntermediateDirectories: false, attributes: nil)
                print("Created Modules folder")
            } catch {
                print("Error: \(error)")
            }
        }

        if !fileManager.fileExists(atPath: themesURL.path, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: themesURL, withIntermediateDirectories: false, attributes: nil)
                print("Created Themes folder")
            } catch {
                print("Error: \(error)")
            }
        }
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("Application directory: \(NSHomeDirectory())")
        
        // create modules and theme folder if they dont exist
        createModuleAndThemesFoldersIfNeeded()
        
        copyFileToDocumentsFolder(nameForFile: "default", extForFile: "theme")
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        
        configuration.delegateClass = SceneDelegate.self
        
        return configuration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
#endif
