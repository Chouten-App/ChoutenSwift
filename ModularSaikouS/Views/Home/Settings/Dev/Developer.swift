//
//  Developer.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI

struct Developer: View {
    @StateObject var Colors = DynamicColors.shared
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var globalData = GlobalData.shared
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Text("Developer")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .center) {
                Button {
                    for userData in userInfo {
                        moc.delete(userData)
                    }
                    do {
                        try moc.save()
                    } catch {
                        // handle the Core Data error
                    }
                } label: {
                    Text("Clear CoreData")
                        .fontWeight(.bold)
                        .foregroundColor(
                            Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.onError.dark
                                        : Colors.onError.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.onError.dark
                                        : Colors.onError.light
                                      )
                                     )
                        )
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background {
                            
                                Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Error.dark
                                            : Colors.Error.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Error.dark
                                            : Colors.Error.light
                                          )
                                         )
                                .cornerRadius(12)
                        }
                }
                
                Button {
                    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        do {
                            try FileManager.default.removeItem(at: documentsDirectory.appendingPathComponent("Modules"))
                            try FileManager.default.createDirectory(at: documentsDirectory.appendingPathComponent("Modules"), withIntermediateDirectories: false, attributes: nil)
                            globalData.availableModules = []
                            globalData.newModule = nil
                        } catch {
                            print("Error getting directory contents: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Delete Installed Modules")
                        .fontWeight(.bold)
                        .foregroundColor(
                            Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.onError.dark
                                        : Colors.onError.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.onError.dark
                                        : Colors.onError.light
                                      )
                                     )
                        )
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background {
                            
                                Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Error.dark
                                            : Colors.Error.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Error.dark
                                            : Colors.Error.light
                                          )
                                         )
                                .cornerRadius(12)
                        }
                }
                
                Button {
                    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        do {
                            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                            let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
                            for fileURL in jsonFiles {
                                let fileData = try Data(contentsOf: fileURL)
                                // Do something with the file data
                                do {
                                    let decoded = try JSONDecoder().decode(OLDModule.self, from: fileData)
                                    globalData.availableModulesOLD.append(decoded)
                                    globalData.availableJsons.append(fileURL)
                                } catch let error {
                                    print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                }
                            }
                        } catch {
                            print("Error getting directory contents: \(error.localizedDescription)")
                        }
                    }
                    if userInfo.count > 0 {
                        Colors.getFromJson(fileName: userInfo[0].selectedTheme ?? "theme")
                        
                        if userInfo[0].selectedAppearance == 0 {
                            globalData.appearance = .light
                        } else if userInfo[0].selectedAppearance == 1 {
                            globalData.appearance = .dark
                        } else {
                            globalData.appearance = .system
                        }
                        
                        let selectedModuleId = userInfo[0].selectedModuleId
                        
                        let temp = globalData.availableModulesOLD.filter { $0.id == selectedModuleId }
                        if temp.count > 0 {
                            globalData.module = temp[0]
                        }
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Force Reload Modules")
                                .fontWeight(.semibold)
                            Text("Reruns the home onAppear Code")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                    }
                }
                
                Button {
                    globalData.downloadedOnly.toggle()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Toggle Log Button")
                                .fontWeight(.semibold)
                            Text("Toggle a left aligned button to go to Logs")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                        
                        Toggle(isOn: $globalData.showLogsButton, label: {})
                            .toggleStyle(M3ToggleStyle(Colors: Colors))
                    }
                }
                
                NavigationLink(destination: LogsDisplay()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Logs")
                                .fontWeight(.semibold)
                            Text("See logs modules")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .foregroundColor(
            Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onSurface.dark
                                : Colors.onSurface.light
                              )
                             )
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  )
                 )
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Developer_Previews: PreviewProvider {
    static var previews: some View {
        Developer()
    }
}
