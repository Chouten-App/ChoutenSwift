//
//  OverlappingCard.swift
//  ModularSaikouS
//
//  Created by Inumaki on 10.04.23.
//

import SwiftUI
import Kingfisher
import SwiftUIX

struct OverlappingCard: View {
    let proxy: GeometryProxy
    @ObservedObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    var body: some View {
        KFImage(URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx145139-rRimpHGWLhym.png"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: proxy.size.width, maxHeight: 360)
            .clipped()
            .cornerRadius([.bottomLeading, .bottomTrailing], 12)
            .overlay {
                LinearGradient(stops: [Gradient.Stop(color: .clear, location: 0.0), Gradient.Stop(color:
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
                                                                                                        ), location: 1.0)], startPoint: .top, endPoint: .bottom)
                    .cornerRadius(10)
            }
    }
}

struct OverlappingCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {proxy in
            VStack {
                PaginationView {
                    OverlappingCard(proxy: proxy, Colors: DynamicColors())
                    OverlappingCard(proxy: proxy, Colors: DynamicColors())
                    OverlappingCard(proxy: proxy, Colors: DynamicColors())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .background(Color("n1-900"))
    }
}
