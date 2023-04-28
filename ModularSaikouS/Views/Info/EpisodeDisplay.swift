//
//  EpisodeDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.04.23.
//

import SwiftUI
import Kingfisher

struct EpisodeDisplay: View {
    let proxy: GeometryProxy
    @StateObject var globalData: GlobalData
    @StateObject var Colors: DynamicColors
    @Binding var navigating: Bool
    
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<globalData.infoData!.mediaList[0].count, id: \.self) {index in
                    NavigationLink(destination: globalData.infoData!.mediaType.lowercased() == "episodes" ? AnyView(WatchPage(url: globalData.infoData!.mediaList[0][index].url, number: index, globalData: globalData)) : AnyView(Reader(url: globalData.infoData!.mediaList[0][index].url, selectedMediaIndex: index, globalData: globalData))) {
                        ZStack {
                            Color(hex: colorScheme == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 8) {
                                    KFImage(URL(string: globalData.infoData!.mediaList[0][index].image ?? globalData.infoData!.poster))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 150, maxHeight: 90)
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        
                                        HStack {
                                            Text(globalData.infoData!.mediaList[0][index].title ?? "Episode \(globalData.infoData!.mediaList[0][index].number)")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        Spacer()
                                        
                                        HStack {
                                            Text("Episode \(forTrailingZero(temp: globalData.infoData!.mediaList[0][index].number))")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Text("24 mins")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                        }
                                        .opacity(0.7)
                                        .padding(.bottom, 6)
                                    }
                                    .padding(.trailing, 8)
                                    .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                }
                                if globalData.infoData!.mediaList[0][index].description != nil {
                                    Text(globalData.infoData!.mediaList[0][index].description!)
                                        .font(.caption)
                                        .lineLimit(4)
                                        .opacity(0.7)
                                        .padding(12)
                                }
                            }
                        }
                        .cornerRadius(12)
                        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                        
                    }.simultaneousGesture(TapGesture().onEnded {
                        print("Hello world!")
                        navigating = true
                    })
                }
            }
            .padding(.bottom, 60)
        }
        .padding(.top, 12)
        .frame(maxHeight: 700)
    }
}

struct EpisodeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {proxy in
            EpisodeDisplay(proxy: proxy, globalData: GlobalData(), Colors: DynamicColors(), navigating: .constant(false))
        }
    }
}
