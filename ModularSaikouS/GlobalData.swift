//
//  GlobalData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

class GlobalData: ObservableObject {
    @Published var selectedModule: String?
    @Published var jsSource: String?
    @Published var arg: String?
    @Published var url: String?
    @Published var module: Module?
    
    @Published var reloadPlease: Bool = false
    
    @Published var moduleText: String?
    @Published var moduleData: SearchData?
    @Published var searchResults: [SearchData] = []
    @Published var infoData: InfoData? = nil
    @Published var nextUrl: String? = nil
    @Published var mediaConsumeLink: String? = nil
    
    @Published var doneInfo: Bool = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSharedJson(_:)), name: .sharedJson, object: nil)
    }
    
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
