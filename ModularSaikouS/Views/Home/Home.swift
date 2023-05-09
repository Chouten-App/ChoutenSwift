//
//  Home.swift
//  ModularSaikouS
//
//  Created by Inumaki on 24.03.23.
//

import SwiftUI
import Kingfisher
import SwiftUIX
import PopupView

struct CarouselData: Codable {
    let titles: Titles
    let genres: [String]
    let description: String
    let image: String
}

struct FloatyData {
    var message: String
    let error: Bool
    var action: FloatyAction?
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

enum AppearanceStyle: String, CaseIterable {
    case light, dark, system
}

struct Home: View {
    @StateObject var globalData = GlobalData.shared
    @StateObject var networkMonitor = NetworkMonitor.shared
    
    // temp data
    var carouselList: [CarouselData] = [
        CarouselData(titles: Titles(primary: "Bungo Stray Dogs 4", secondary: "文豪ストレイドッグス 第4シーズン"), genres: ["Action", "Comedy", "Mystery", "Supernatural"], description: "The fourth season of *Bungou Stray Dogs*", image: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
        CarouselData(titles: Titles(primary: "Bungo Stray Dogs 4", secondary: "文豪ストレイドッグス 第4シーズン"), genres: ["Action", "Comedy", "Mystery", "Supernatural"], description: "The fourth season of *Bungou Stray Dogs*", image: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
        CarouselData(titles: Titles(primary: "Bungo Stray Dogs 4", secondary: "文豪ストレイドッグス 第4シーズン"), genres: ["Action", "Comedy", "Mystery", "Supernatural"], description: "The fourth season of *Bungou Stray Dogs*", image: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
        CarouselData(titles: Titles(primary: "Bungo Stray Dogs 4", secondary: "文豪ストレイドッグス 第4シーズン"), genres: ["Action", "Comedy", "Mystery", "Supernatural"], description: "The fourth season of *Bungou Stray Dogs*", image: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
        CarouselData(titles: Titles(primary: "Bungo Stray Dogs 4", secondary: "文豪ストレイドッグス 第4シーズン"), genres: ["Action", "Comedy", "Mystery", "Supernatural"], description: "The fourth season of *Bungou Stray Dogs*", image: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
    ]
    @State var currentCarouselIndex = 0
    
    @State var selectedTab = 0
    
    @Namespace var animation
    
    @StateObject var Colors: DynamicColors = DynamicColors()
    
    @State var showPopup = false
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @State var availableModules: [OLDModule] = []
    @State var selectedModuleId: String? = nil
    
    @State var showFloaty = false
    @State var floatyMessage = ""
    @State var floatyError = false
    @State var floatyAction: FloatyAction? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    
    
    @StateObject var moduleManager = ModuleManager.shared
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                // banner
                if globalData.downloadedOnly {
                    ZStack(alignment: .bottom) {
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.Tertiary.dark
                                : Colors.Tertiary.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.Tertiary.dark
                                : Colors.Tertiary.light
                              )
                        )
                        
                        Text("Downloaded only")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.onTertiary.dark
                                        : Colors.onTertiary.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.onTertiary.dark
                                        : Colors.onTertiary.light
                                      )
                                     )
                            )
                            .padding(.bottom, 8)
                            .padding(.top, proxy.safeAreaInsets.top)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.easeOut, value: globalData.downloadedOnly)
                }
                
                if globalData.incognito {
                    ZStack(alignment: .bottom) {
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.Primary.dark
                                : Colors.Primary.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.Primary.dark
                                : Colors.Primary.light
                              )
                        )
                        
                        Text("Incognito")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.onPrimary.dark
                                        : Colors.onPrimary.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.onPrimary.dark
                                        : Colors.onPrimary.light
                                      )
                                     )
                            )
                            .padding(.vertical, 8)
                            .padding(.top, !globalData.downloadedOnly ? proxy.safeAreaInsets.top : 0)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.easeOut, value: globalData.incognito)
                }
                
                NavigationView {
                    GeometryReader {proxy in
                        TabView(selection: $selectedTab) {
                            VStack {
                                Text("Nothing to see yet .-.")
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
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Button {
                                    globalData.downloadedOnly.toggle()
                                } label: {
                                    Text("Toggle Downloaded Only")
                                        .fontWeight(.bold)
                                        .foregroundColor(
                                            Color(hex:
                                                        globalData.appearance == .system
                                                      ? (
                                                        colorScheme == .dark
                                                        ? Colors.onPrimary.dark
                                                        : Colors.onPrimary.light
                                                      ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.onPrimary.dark
                                                        : Colors.onPrimary.light
                                                      )
                                                     )
                                        )
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                        .background {
                                            
                                                Color(hex:
                                                            globalData.appearance == .system
                                                          ? (
                                                            colorScheme == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          ) : (
                                                            globalData.appearance == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          )
                                                         )
                                                .cornerRadius(12)
                                        }
                                }
                                .padding(.horizontal, 40)
                                .padding(.bottom, 20)
                                
                                Button {
                                    globalData.incognito.toggle()
                                } label: {
                                    Text("Toggle Incognito")
                                        .fontWeight(.bold)
                                        .foregroundColor(
                                            Color(hex:
                                                        globalData.appearance == .system
                                                      ? (
                                                        colorScheme == .dark
                                                        ? Colors.onPrimary.dark
                                                        : Colors.onPrimary.light
                                                      ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.onPrimary.dark
                                                        : Colors.onPrimary.light
                                                      )
                                                     )
                                        )
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                        .background {
                                            
                                                Color(hex:
                                                            globalData.appearance == .system
                                                          ? (
                                                            colorScheme == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          ) : (
                                                            globalData.appearance == .dark
                                                            ? Colors.Primary.dark
                                                            : Colors.Primary.light
                                                          )
                                                         )
                                                .cornerRadius(12)
                                        }
                                }
                                .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                            .tag(0)
                            
                            Search(Colors: Colors)
                                .tag(1)
                            
                            VStack {
                                Text("YO MAMA")
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                            .tag(2)
                            
                            More(Colors: Colors)
                                .tag(3)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .bottomTrailing) {
                        if selectedTab != 3 {
                            Button {
                                globalData.showModuleSelector.toggle()
                            } label: {
                                Text(globalData.newModule == nil ? "No Module" : globalData.newModule!.name)
                                    .font(.system(size: 18, weight: .bold))
                                .padding(.horizontal, 24)
                                .frame(minWidth: 80, maxHeight: 56)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            Color(hex:
                                                    globalData.appearance == .system
                                                  ? (
                                                    colorScheme == .dark
                                                    ? Colors.SecondaryContainer.dark
                                                    : Colors.SecondaryContainer.light
                                                  ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.SecondaryContainer.dark
                                                    : Colors.SecondaryContainer.light
                                                  )
                                                 )
                                        )
                                }
                                .shadow(color: Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.Scrim.dark
                                                        : Colors.Scrim.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.Scrim.dark
                                                        : Colors.Scrim.light
                                                     )
                                                    ).opacity(0.08), radius: 2, x: 0, y: 0)
                                .shadow(color: Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.Scrim.dark
                                                        : Colors.Scrim.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.Scrim.dark
                                                        : Colors.Scrim.light
                                                     )
                                                    ).opacity(0.16), radius: 24, x: 0, y: 0)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing, 16)
                            .padding(.bottom, 120)
                            .foregroundColor(Color(hex:
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
                        }
                    }
                    .overlay {
                        BottomSheet(isShowing: $globalData.showModuleSelector, content: AnyView(ModuleSelector(showPopup: $globalData.showModuleSelector, Colors: Colors)))
                            .padding(.bottom, 100)
                    }
                    .overlay(alignment: .bottom) {
                        Navbar(selectedTab: $selectedTab, Colors: Colors)
                    }
                    .overlay {
                        if showPopup {
                            ZStack {
                                Color.black.opacity(0.5)
                                    .onTapGesture {
                                        showPopup = false
                                    }
                                
                                UrlPopup(Colors: Colors, showPopup: $showPopup)
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
                .navigationViewStyle(.stack)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .ignoresSafeArea()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .animation(.easeOut, value: globalData.incognito)
        .animation(.easeOut, value: globalData.downloadedOnly)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("floaty")), perform: { value in
            if value.userInfo != nil {
                if value.userInfo!["data"] != nil {
                    let floatyData = value.userInfo!["data"] as! FloatyData
                    floatyMessage = floatyData.message
                    floatyAction = floatyData.action
                    floatyError = floatyData.error
                    showFloaty = true
                }
            }
        })
        .onReceive(networkMonitor.$connected) { hasInternet in
            print(hasInternet)
            globalData.downloadedOnly = !hasInternet
        }
        .onAppear{
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                    let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
                    for fileURL in jsonFiles {
                        let fileData = try Data(contentsOf: fileURL)
                        print(fileData)
                        // Do something with the file data
                        do {
                            let decoded = try JSONDecoder().decode(OLDModule.self, from: fileData)
                            globalData.availableModulesOLD.append(decoded)
                            globalData.availableJsons.append(fileURL)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    for moduleFolder in moduleManager.moduleFolderNames {
                        let data = moduleManager.getMetadata(folderUrl: documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(moduleFolder))
                        
                        if data != nil {
                            globalData.availableModules.append(data!)
                            moduleManager.moduleIds.append(data!.id)
                        }
                    }
                    
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
            if userInfo.count > 0 {
                Colors.getFromJson(fileName: userInfo[0].selectedTheme ?? "default")
                
                print(userInfo[0])
                
                if userInfo[0].selectedAppearance == 0 {
                    globalData.appearance = .light
                } else if userInfo[0].selectedAppearance == 1 {
                    globalData.appearance = .dark
                } else {
                    globalData.appearance = .system
                }
                
                print(globalData.appearance)
                
                selectedModuleId = userInfo[0].selectedModuleId
                                
                let temp = globalData.availableModules.filter { $0.id == selectedModuleId }
                if temp.count > 0 {
                    globalData.newModule = temp[0]
                    if selectedModuleId != nil {
                        let index = moduleManager.moduleIds.firstIndex(of: selectedModuleId!)
                        if index != nil {
                            moduleManager.selectedModuleName = moduleManager.moduleFolderNames[index!]
                        }
                    }
                }
            }
        }
        .popup(isPresented: $showFloaty) {
            FloatyDisplay(Colors: Colors, message: $floatyMessage, error: $floatyError, action: floatyAction, showFloaty: $showFloaty)
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .autohideIn(4.0)
        }
    }
}

struct CarouselItem: View {
    let proxy: GeometryProxy
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {reader in
                FillAspectImage(
                    url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
                    doesAnimateHorizontal: true
                )
                .blur(radius: 0.0)
                .overlay {
                    LinearGradient(stops: [
                        Gradient.Stop(color: Color("n1-900").opacity(0.9), location: 0.0),
                        Gradient.Stop(color: Color("n1-900").opacity(0.4), location: 1.0),
                    ], startPoint: .bottom, endPoint: .top)
                }
                .frame(
                    width: reader.size.width,
                    height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                    alignment: .center
                )
                .contentShape(Rectangle())
                .clipped()
                .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                
            }
            .frame(height: 380)
            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("文豪ストレイドッグス 第4シーズン")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("a1-300").opacity(0.7))
                    Text("Bungo Stray Dogs 4")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("a1-300"))
                }
                Text("Action • Comedy • Mystery • Supernatural")
                    .font(.headline)
                    .foregroundColor(Color("a2-100"))
                Text("The fourth season of *Bungou Stray Dogs*")
                    .font(.subheadline)
                    .foregroundColor(Color("a2-100").opacity(0.7))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, alignment: .bottomLeading)
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
