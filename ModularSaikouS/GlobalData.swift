//
//  GlobalData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

class GlobalData: ObservableObject {
    static let shared = GlobalData()
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSharedJson(_:)), name: .sharedJson, object: nil)
    }
    
    @Published var showModuleSelector: Bool = false
    
    @Published var selectedModule: String?
    @Published var jsSource: String?
    @Published var arg: String?
    @Published var url: String?
    @Published var module: OLDModule?
    @Published var newModule: Module?
    @Published var availableModulesOLD: [OLDModule] = []
    @Published var availableModules: [Module] = []
    @Published var availableJsons: [URL] = []
    @Published var appearance = AppearanceStyle.system
    
    @Published var reloadPlease: Bool = false
    
    @Published var moduleText: String?
    @Published var moduleData: SearchData?
    @Published var homeComponents: [HomeComponent] = []
    @Published var searchResults: [SearchData] = []
    @Published var infoData: InfoData? = nil
    @Published var lastVisitedEntry: String = ""
    @Published var nextUrl: String? = nil
    @Published var mediaConsumeLink: String? = nil
    
    @Published var doneInfo: Bool = false
    
    @Published var downloadedOnly: Bool = false
    @Published var incognito: Bool = false
    
    
    @Published var isLoading = false
    @Published var isLoadingHomepage = false
    @Published var mediaFailedToLoad = false
    
    @objc private func handleSharedJson(_ notification: Notification) {
        if let url = notification.userInfo?["url"] as? URL {
            do {
                let data = try Data(contentsOf: url)
                let fileName = url.lastPathComponent
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                let fileURL = documentsDirectory.appendingPathComponent(fileName.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "/", with: ""))
                do {
                    try data.write(to: fileURL, options: .atomic)
                    print("File saved successfully: \(fileURL.absoluteString)")
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
