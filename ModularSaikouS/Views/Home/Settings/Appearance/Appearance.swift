//
//  Appearance.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.04.23.
//

import SwiftUI

struct Appearance: View {
    @StateObject var Colors: DynamicColors
    
    @State var themes: [JSONColors] = []
    @State var themesFileNames: [String] = []
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Text("Appearance")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<themes.count, id: \.self) {index in
                        ThemePreview(bgColor1: colorScheme == .dark ? themes[index].dark.SurfaceContainer : themes[index].light.SurfaceContainer, bgColor2: colorScheme == .dark ? themes[index].dark.Surface : themes[index].light.Surface, bgColor3: colorScheme == .dark ? themes[index].dark.SurfaceContainerHigh : themes[index].light.SurfaceContainerHigh, accentColor1: colorScheme == .dark ? themes[index].dark.Primary : themes[index].light.Primary, accentColor2: colorScheme == .dark ? themes[index].dark.Secondary : themes[index].light.Secondary, accentColor3: colorScheme == .dark ? themes[index].dark.Primary : themes[index].light.Primary, accentColor4: colorScheme == .dark ? themes[index].dark.Tertiary : themes[index].light.Tertiary, accentColor5: colorScheme == .dark ? themes[index].dark.onPrimaryContainer : themes[index].light.onPrimaryContainer)
                            .frame(minWidth: 150, minHeight: 220)
                            .overlay {
                                Text(themes[index].dark.Primary)
                            }
                            .onTapGesture {
                                Colors.setFromModel(jsonColors: themes[index])
                                if userInfo.count > 0 {
                                    print("updating")
                                    do {
                                        userInfo[0].selectedTheme = themesFileNames[index]
                                        try moc.save()
                                    } catch let error {
                                        print(error)
                                    }
                                } else {
                                    print("adding")
                                    do {
                                        let info = UserInfo(context: moc)
                                        info.selectedTheme = themesFileNames[index]
                                        try moc.save()
                                    } catch let error {
                                        print(error)
                                    }
                                }
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 240)
            
            // Theme Editor
            
            Text("Editor")
                .font(.title2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                    let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
                    for fileURL in jsonFiles {
                        let fileData = try Data(contentsOf: fileURL)
                        print(fileData)
                        // Do something with the file data
                        do {
                            let decoded = try JSONDecoder().decode(JSONColors.self, from: fileData)
                            themes.append(decoded)
                            themesFileNames.append(fileURL.lastPathComponent.replacingOccurrences(of: ".json", with: ""))
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
        }
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Appearance_Previews: PreviewProvider {
    static var previews: some View {
        Appearance(Colors: DynamicColors())
    }
}
