//
//  SwiftUIView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 21.03.23.
//

#if os(macOS)
import SwiftUI

extension Notification.Name {
    static let sharedJson = Notification.Name("com.chouten.shared.json")
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

@main
struct Chouten: App {
    //@NSApplicationDelegateAdaptor(AppDelegate.self)
    //var appDelegate

    var body: some Scene {
        WindowGroup {
            Search()
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
                
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.expanded)
        .commands {
            CommandGroup(after: .appInfo) {
                Button {} label: {
                    Text("Check for Updates...")
                }
            }
            CommandGroup(after: .appInfo) {
                Button {} label: {
                    Text("Check for Updates...")
                }
            }
            CommandGroup(after: .appInfo) {
                Button {} label: {
                    Text("Check for Updates...")
                }
            }
        }

        Settings {
            VStack {
                Text("Settings")
            }
            .frame(width: 450, height: 400)
            .background {
                Color("bg")
            }
            .onAppear {
                // Hide the titlebar of the Settings window
                let settingsWindow = NSApplication.shared.windows.last!
                settingsWindow.styleMask.insert(.fullSizeContentView)
                settingsWindow.titlebarAppearsTransparent = true
                settingsWindow.isMovableByWindowBackground = true
                settingsWindow.standardWindowButton(.closeButton)?.isHidden = true
            }
        }
        .windowToolbarStyle(.unified)
    }
}
#endif
