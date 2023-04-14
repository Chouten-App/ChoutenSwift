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
    
    var body: some View {
        NavigationView {
            GeometryReader {proxy in
                TabView(selection: $selectedTab) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            PaginationView(axis: .horizontal) {
                                ForEach(0..<carouselList.count, id: \.self) { index in
                                    CarouselItem(proxy: proxy)
                                        .frame(height: 380)
                                        .frame(width: proxy.size.width)
                                }
                            }
                            .currentPageIndex($currentCarouselIndex)
                            .frame(height: 380)
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
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Color("bg")
                    }
                    .ignoresSafeArea()
                    .tag(0)
                    
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
                    .tag(1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
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
            .padding(.bottom, 80)
        }
        .overlay {
            BottomSheet(isShowing: $showModuleSelector, content: AnyView(ModuleSelector(globalData: globalData)))
        }
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "house.fill")
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
                        .foregroundColor(Color("textColor2"))
                }
                .onTapGesture {
                    selectedTab = 0
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "gear")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedTab == 1 ? Color("textColor") : Color("textColor2"))
                        .background {
                            Capsule()
                                .fill(Color("accentColor1"))
                                .opacity(selectedTab == 1 ? 1.0 : 0.0)
                                .animation(.spring(response: 0.3), value: selectedTab)
                        }
                    Text("Settings")
                        .foregroundColor(Color("textColor2"))
                }
                .onTapGesture {
                    selectedTab = 1
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background {
                Color("bg2")
            }
        }
        .ignoresSafeArea()
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
