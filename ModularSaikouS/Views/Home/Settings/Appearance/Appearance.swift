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
                        
                        Text("Appearance")
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
                    .padding(.horizontal, 20)
                    
                    // Theme Editor
                    
                    Text("Editor")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 4) {
                        Text("Primary")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        (colorScheme == .dark
                                        ? (tab == 0 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 0 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      ) : (
                                        (globalData.appearance == .dark
                                        ? (tab == 0 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 0 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      )
                                     )
                            )
                            .padding(4)
                            .frame(width: proxy.size.width / 3 - 20)
                            .background{
                                if tab == 0 {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            Color(hex:
                                                    globalData.appearance == .system
                                                  ? (
                                                    colorScheme == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  )
                                                 )
                                        )
                                        .matchedGeometryEffect(id: "TABS", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    tab = 0
                                }
                            }
                            .padding(.leading, 4)
                        
                        Text("Secondary")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        (colorScheme == .dark
                                        ? (tab == 1 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 1 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      ) : (
                                        (globalData.appearance == .dark
                                        ? (tab == 1 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 1 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      )
                                     )
                            )
                            .padding(4)
                            .frame(width: proxy.size.width / 3 - 20)
                            .background{
                                if tab == 1 {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            Color(hex:
                                                    globalData.appearance == .system
                                                  ? (
                                                    colorScheme == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  )
                                                 )
                                        )
                                        .matchedGeometryEffect(id: "TABS", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    tab = 1
                                }
                            }
                        
                        Text("Tertiary")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        (colorScheme == .dark
                                        ? (tab == 2 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 2 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      ) : (
                                        (globalData.appearance == .dark
                                        ? (tab == 2 ? Colors.onPrimary.dark : Colors.onPrimaryContainer.dark)
                                        : (tab == 2 ? Colors.onPrimary.light : Colors.onPrimaryContainer.light))
                                      )
                                     )
                            )
                            .padding(4)
                            .frame(width: proxy.size.width / 3 - 20)
                            .background{
                                if tab == 2 {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            Color(hex:
                                                    globalData.appearance == .system
                                                  ? (
                                                    colorScheme == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.onPrimaryContainer.dark
                                                    : Colors.onPrimaryContainer.light
                                                  )
                                                 )
                                        )
                                        .matchedGeometryEffect(id: "TABS", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    tab = 2
                                }
                            }
                            .padding(.trailing, 4)
                    }
                    .padding(4)
                    .frame(maxWidth: proxy.size.width - 40)
                    .background{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.SurfaceContainer.dark
                                        : Colors.SurfaceContainer.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.SurfaceContainer.dark
                                        : Colors.SurfaceContainer.light
                                      )
                                     )
                            )
                        
                    }
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
