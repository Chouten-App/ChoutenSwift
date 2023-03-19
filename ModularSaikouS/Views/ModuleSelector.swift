//
//  ModuleSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

struct Module: Codable, Hashable {
    var moduleName: String
    var moduleVersion: String
    var js: String
    var website: String
}

struct ModuleSelector: View{
    @StateObject var globalData: GlobalData
    let buttonHeight: CGFloat = 55
    @State var availableModules: [Module] = []
    
    func loadData(module: Module)  {
        globalData.jsSource = module.js
        globalData.selectedModule = module.moduleName
        globalData.url = module.website
    }
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack {
                Text("Module Selector")
                    .font(.system(size: 20, weight: .bold))
                
            }
            .padding(.top, 16)
            .padding(.bottom, 4)
            
            Text("Select one of the modules below to get provide this app with data:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 24)
            
            ForEach(availableModules, id: \.self) {module in
                ButtonLarge(label: module.moduleName, background: .pink.opacity(0.95), textColor: .white, action: {
                    // Action will be here
                    loadData(module: module)
                })
                .frame(height: buttonHeight)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
        .foregroundColor(.white)
        .background {
            Color(.black)
        }
        .onAppear {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                    let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
                    for fileURL in jsonFiles {
                        let fileData = try Data(contentsOf: fileURL)
                        // Do something with the file data
                        let decoded = try? JSONDecoder().decode(Module.self, from: fileData)
                        if decoded != nil {
                            availableModules.append(decoded!)
                        }
                    }
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ModuleSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModuleSelector(globalData: GlobalData())
    }
}
