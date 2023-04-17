//
//  Home.swift
//  ModularSaikouS
//
//  Created by Inumaki on 24.03.23.
//

import SwiftUI
import Kingfisher
import SwiftUIX

struct CarouselData: Codable {
    let titles: Titles
    let genres: [String]
    let description: String
    let image: String
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


struct Home: View {
    
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
    @StateObject var globalData: GlobalData = GlobalData()
    
    @State var showPopup = false
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @State var availableModules: [Module] = []
    @State var selectedModuleId: String? = nil
    
    var body: some View {
        NavigationView {
            GeometryReader {proxy in
                TabView(selection: $selectedTab) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            PaginationView(axis: .horizontal) {
                                ForEach(0..<carouselList.count, id: \.self) { index in
                                    OverlappingCard(proxy: proxy)
                                }
                            }
                            .currentPageIndex($currentCarouselIndex)
                            .frame(minHeight: 360,maxHeight: 360, alignment: .top)
                            .ignoresSafeArea()
                            .pageIndicatorTintColor(Color("textColor2").opacity(0.0))
                            .currentPageIndicatorTintColor(Color("accentColor1").opacity(0.0))
                            .overlay(alignment: .bottom) {
                                HStack {
                                    ForEach(0..<carouselList.count, id: \.self) { index in
                                        if index == currentCarouselIndex {
                                            Capsule()
                                                .fill(Color("accentColor1"))
                                                .frame(maxWidth: 16, maxHeight: 8)
                                        } else {
                                            Circle()
                                                .fill(Color("textColor"))
                                                .frame(maxWidth: 6, maxHeight: 6)
                                        }
                                    }
                                }
                            }
                            .overlay(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Trending")
                                            .foregroundColor(Color("textColor"))
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 3)
                                            .background {
                                                Capsule()
                                                    .fill(Color("accentColor1"))
                                            }
                                        Spacer()
                                        Text("8.8")
                                            .fontWeight(.semibold)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color("accentColor2"))
                                    }
                                    
                                    Text("Demon Slayer: Kimetsu no Yaiba Swordsmith Village Arc")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .lineLimit(3)
                                    Text("鬼滅の刃 刀鍛冶の里編")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .opacity(0.7)
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .top) {
                                        Text("Genre: ")
                                        Text("Action • Adventure • Drama")
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                    }
                                    .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("Watch Now")
                                            .foregroundColor(Color("accentColor2"))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(Color("textColor"))
                                            .padding(6)
                                            .background {
                                                Circle()
                                                    .fill(Color("accentColor1"))
                                            }
                                    }
                                }
                                .foregroundColor(Color("textColor2"))
                                .padding(20)
                                .frame(maxWidth: .infinity, maxHeight: 220, alignment: .topLeading)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("bg2"))
                                }
                                .shadow(radius: 12)
                                .padding(.horizontal, 12)
                                .offset(y: 100)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Recently Released")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 12) {
                                        ForEach(0..<6) {index in
                                            SearchCard(image: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx150672-2WWJVXIAOG11.png", title: "Oshi No Ko", hasIndicator: false, indicatorText: "", currentCount: nil, totalCount: nil, type: SearchCardType.GRID, cover: nil)
                                        }
                                    }
                                    .padding(.trailing, 20)
                                }
                                .frame(maxWidth: proxy.size.width)
                                .padding(.trailing, -20)
                                
                                Text("Recently Released")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                
                                ScrollView(.horizontal) {
                                    LazyHGrid(rows: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 12) {
                                        ForEach(0..<16) {index in
                                            VStack {
                                                KFImage(URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx150672-2WWJVXIAOG11.png"))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxHeight: 280)
                                                
                                                Text("Oshi No Ko")
                                                    .font(.caption)
                                            }
                                            .foregroundColor(Color("textColor2"))
                                        }
                                    }
                                    .frame(maxHeight: 600)
                                    .padding(.trailing, 20)
                                }
                                .frame(maxWidth: proxy.size.width)
                                .padding(.trailing, -20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 110)
                        }
                        .padding(.bottom, 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .ignoresSafeArea()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Color("bg")
                    }
                    .ignoresSafeArea()
                    .tag(0)
                    
                    Search(globalData: globalData)
                        .tag(1)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 40)
                        
                        HStack {
                            Image(systemName: "gear")
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text("General")
                                    .fontWeight(.semibold)
                                Text("Some text idk")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .opacity(0.7)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        
                        HStack {
                            Image(systemName: "gear")
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text("Developer")
                                    .fontWeight(.semibold)
                                Text("Only Dev Stuff. Dont Touch!")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .opacity(0.7)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 220)
                    .foregroundColor(Color("textColor2"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background {
                        Color("bg")
                    }
                    .ignoresSafeArea()
                    .tag(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showModuleSelector.toggle()
                } label: {
                    Text(globalData.module == nil ? "No Module" : globalData.module!.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color("textColor"))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("accentColor1"))
                        }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 20)
                .padding(.bottom, 130)
            }
            .overlay {
                BottomSheet(isShowing: $showModuleSelector, content: AnyView(ModuleSelector(globalData: globalData, showPopup: .constant(true))))
                    .padding(.bottom, 100)
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Spacer()
                    
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedTab == 0 ? Color("textColor") : Color("textColor2"))
                            .background {
                                Capsule()
                                    .fill(Color("accentColor1"))
                                    .opacity(selectedTab == 0 ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.3), value: selectedTab)
                            }
                        Text("Home")
                            .font(.subheadline)
                            .fontWeight(selectedTab == 0 ? .bold : .medium)
                            .foregroundColor(Color("textColor2"))
                    }
                    .onTapGesture {
                        selectedTab = 0
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedTab == 1 ? Color("textColor") : Color("textColor2"))
                            .background {
                                Capsule()
                                    .fill(Color("accentColor1"))
                                    .opacity(selectedTab == 1 ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.3), value: selectedTab)
                            }
                        Text("Search")
                            .font(.subheadline)
                            .fontWeight(selectedTab == 1 ? .bold : .medium)
                            .foregroundColor(Color("textColor2"))
                    }
                    .onTapGesture {
                        selectedTab = 1
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "gear")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedTab == 2 ? Color("textColor") : Color("textColor2"))
                            .background {
                                Capsule()
                                    .fill(Color("accentColor1"))
                                    .opacity(selectedTab == 2 ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.3), value: selectedTab)
                            }
                        Text("Settings")
                            .font(.subheadline)
                            .fontWeight(selectedTab == 2 ? .bold : .medium)
                            .foregroundColor(Color("textColor2"))
                    }
                    .onTapGesture {
                        selectedTab = 2
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 12)
                .frame(maxWidth: .infinity, maxHeight: 110, alignment: .top)
                .background {
                    Color("bg2")
                }
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("accentColor1"))
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .padding(.horizontal, 20)
                        .offset(y: -8)
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
                            print(decoded)
                            if decoded != nil {
                                availableModules.append(decoded)
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
            if userInfo.count > 0 {
                selectedModuleId = userInfo[0].selectedModuleId
                let temp = availableModules.filter { $0.id == selectedModuleId }
                if temp.count > 0 {
                    globalData.module = temp[0]
                }
            }
        }
        .preferredColorScheme(.dark)
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
                        Gradient.Stop(color: Color("bg").opacity(0.9), location: 0.0),
                        Gradient.Stop(color: Color("bg").opacity(0.4), location: 1.0),
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
                        .foregroundColor(Color("accentColor1").opacity(0.7))
                    Text("Bungo Stray Dogs 4")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("accentColor1"))
                }
                Text("Action • Comedy • Mystery • Supernatural")
                    .font(.headline)
                    .foregroundColor(Color("textColor2"))
                Text("The fourth season of *Bungou Stray Dogs*")
                    .font(.subheadline)
                    .foregroundColor(Color("textColor2").opacity(0.7))
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
