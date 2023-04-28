//
//  TestingHome.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI
import SwiftUIX
import Kingfisher

struct TestingHome: View {
    let proxy: GeometryProxy
    let carouselList: [CarouselData]
    @Binding var currentCarouselIndex: Int
    @StateObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                PaginationView(axis: .horizontal) {
                    ForEach(0..<carouselList.count, id: \.self) { index in
                        OverlappingCard(proxy: proxy, Colors: Colors)
                    }
                }
                .currentPageIndex($currentCarouselIndex)
                .frame(minHeight: 360,maxHeight: 360, alignment: .top)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Trending")
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimary.dark : Colors.onPrimary.light))
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 3)
                                .background {
                                    Capsule()
                                        .fill(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
                                }
                            Spacer()
                            Text("8.8")
                                .fontWeight(.semibold)
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.Tertiary.dark : Colors.Tertiary.light))
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
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.Tertiary.dark : Colors.Tertiary.light))
                                .fontWeight(.semibold)
                                .onTapGesture {
                                    let data = ["data": FloatyData(message: "This is a test", action: nil)]
                                    NotificationCenter.default
                                                .post(name:           NSNotification.Name("floaty"),
                                                      object: nil, userInfo: data)
                                }
                            
                            Spacer()
                            
                            Image(systemName: "plus")
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimary.dark : Colors.onPrimary.light))
                                .padding(6)
                                .background {
                                    Circle()
                                        .fill(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
                                }
                        }
                    }
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: 220, alignment: .topLeading)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: colorScheme == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light))
                    }
                    .shadow(radius: 12)
                    .padding(.horizontal, 12)
                    .offset(y: 100)
                }
                
                VStack(alignment: .leading) {
                    Text("Recently Released")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(0..<6) {index in
                                SearchCard(image: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx150672-2WWJVXIAOG11.png", title: "Oshi No Ko", hasIndicator: false, indicatorText: "", currentCount: nil, totalCount: nil, type: SearchCardType.GRID, cover: nil, Colors: Colors)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .frame(maxWidth: proxy.size.width)
                    .padding(.trailing, -20)
                    
                    Text("Recently Released")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                    
                    
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
                                        .cornerRadius(6)
                                    
                                    Text("Oshi No Ko")
                                        .font(.caption)
                                }
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
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
    }
}

struct TestingHome_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            TestingHome(proxy: proxy, carouselList: [], currentCarouselIndex: .constant(1), Colors: DynamicColors())
        }
    }
}
