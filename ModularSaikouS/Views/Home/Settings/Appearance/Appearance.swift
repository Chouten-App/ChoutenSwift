//
//  Appearance.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.04.23.
//

import SwiftUI

struct Appearance: View {
    @StateObject var Colors = DynamicColors.shared
    
    @State var themes: [JSONColors] = []
    @State var themesFileNames: [String] = []
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    @State var tab: Int = 0
    @Namespace var animation
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Text("theme-navigation-title")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<themes.count, id: \.self) {index in
                                ThemePreview(bgColor1: colorScheme == .dark ? themes[index].dark.SurfaceContainer : themes[index].light.SurfaceContainer, bgColor2: colorScheme == .dark ? themes[index].dark.Surface : themes[index].light.Surface, bgColor3: colorScheme == .dark ? themes[index].dark.Error : themes[index].light.Error, accentColor1: colorScheme == .dark ? themes[index].dark.Primary : themes[index].light.Primary, accentColor2: colorScheme == .dark ? themes[index].dark.Secondary : themes[index].light.Secondary, accentColor3: colorScheme == .dark ? themes[index].dark.Primary : themes[index].light.Primary, accentColor4: colorScheme == .dark ? themes[index].dark.Tertiary : themes[index].light.Tertiary, accentColor5: colorScheme == .dark ? themes[index].dark.onPrimaryContainer : themes[index].light.onPrimaryContainer)
                                    .frame(minWidth: 150, minHeight: 220)
                                    .overlay {
                                        Text(themes[index].dark.Primary)
                                    }
                                    .onTapGesture {
                                        Colors.setFromModel(jsonColors: themes[index])
                                        if userInfo.count > 0 {
                                            do {
                                                userInfo[0].selectedTheme = themesFileNames[index]
                                                try moc.save()
                                            } catch let error {
                                                print(error)
                                            }
                                        } else {
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
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
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
        .onAppear {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory.appendingPathComponent("Themes"), includingPropertiesForKeys: nil, options: [])
                    let jsonFiles = directoryContents.filter { $0.pathExtension == "theme" }
                    for fileURL in jsonFiles {
                        let fileData = try Data(contentsOf: fileURL)
                        // Do something with the file data
                        do {
                            let decoded = try JSONDecoder().decode(JSONColors.self, from: fileData)
                            themes.append(decoded)
                            themesFileNames.append(fileURL.lastPathComponent.replacingOccurrences(of: ".theme", with: ""))
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
        }
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Appearance_Previews: PreviewProvider {
    static var previews: some View {
        Appearance()
    }
}
