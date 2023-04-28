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
    
    @State var showModuleSelector = false
    @StateObject var Colors: DynamicColors = DynamicColors()
    
    @State var showPopup = false
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @State var availableModules: [Module] = []
    @State var selectedModuleId: String? = nil
    
    @State var showFloaty = false
    @State var floatyMessage = ""
    @State var floatyAction: FloatyAction? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
                    
                    SettingsView(Colors: Colors)
                        .tag(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                if selectedTab != 2 {
                    Button {
                        showModuleSelector.toggle()
                    } label: {
                        Text(globalData.module == nil ? "No Module" : globalData.module!.name)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
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
                                    )
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 20)
                    .padding(.bottom, 130)
                    .foregroundColor(Color(hex:
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
                }
            }
            .overlay {
                BottomSheet(isShowing: $showModuleSelector, content: AnyView(ModuleSelector(showPopup: $showModuleSelector, Colors: Colors)))
                    .padding(.bottom, 100)
            }
            .overlay(alignment: .bottom) {
                Navbar(selectedTab: $selectedTab, Colors: Colors)
                    .overlay(alignment: .top) {
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
                            .frame(maxWidth: .infinity, maxHeight: 2)
                            .padding(40)
                            .offset(y: -52)
                            .opacity(showModuleSelector ? 1.0 : 0.0)
                    }
            }
            .overlay {
                if showPopup {
                    ZStack {
                        Color.black.opacity(0.5)
                            .onTapGesture {
                                showPopup = false
                            }
                        
                        UrlPopup(showPopup: $showPopup)
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
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("floaty")), perform: { value in
            if value.userInfo != nil {
                if value.userInfo!["data"] != nil {
                    let floatyData = value.userInfo!["data"] as! FloatyData
                    floatyMessage = floatyData.message
                    floatyAction = floatyData.action
                    showFloaty = true
                }
            }
        })
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
                            let decoded = try JSONDecoder().decode(Module.self, from: fileData)
                            globalData.availableModules.append(decoded)
                            globalData.availableJsons.append(fileURL)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
            if userInfo.count > 0 {
                Colors.getFromJson(fileName: userInfo[0].selectedTheme ?? "theme")
                
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
                    globalData.module = temp[0]
                }
            }
        }
        .popup(isPresented: $showFloaty) {
            FloatyDisplay(message: $floatyMessage, showFloaty: $showFloaty, action: floatyAction)
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
