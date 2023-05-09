//
//  InfoDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.04.23.
//

import SwiftUI
import Kingfisher

struct InfoDisplay: View {
    @StateObject var Colors: DynamicColors
    
    let proxy: GeometryProxy
    @Binding var showHeader: Bool
    let title: String
    @Binding var showFullDescription: Bool
    @Binding var isOn: Bool
    @Binding var navigating: Bool
    var animation: Namespace.ID?
    @StateObject var globalData = GlobalData.shared
    
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if globalData.infoData != nil {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
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
                        
                        Text(globalData.infoData!.titles.primary)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .padding(12)
                    }
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
                                          ))
                    .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, maxHeight: 110, alignment: .bottomLeading)
                    .padding(.bottom, -60)
                    
                    
                    ZStack(alignment: .bottomLeading) {
                        GeometryReader {reader in
                            FillAspectImage(
                                url: URL(string: globalData.infoData!.banner ?? globalData.infoData!.poster),
                                doesAnimateHorizontal: proxy.size.width < 900
                            )
                            .blur(radius: globalData.infoData!.banner != nil ? 0.0 : 6.0)
                            .overlay {
                                LinearGradient(stops: [
                                    Gradient.Stop(color: Color(hex:
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
                                                              ).opacity(0.9), location: 0.0),
                                    Gradient.Stop(color: Color(hex:
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
                                                              ).opacity(0.4), location: 1.0),
                                ], startPoint: .bottom, endPoint: .top)
                            }
                            .frame(
                                width: reader.size.width,
                                height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                                alignment: .top
                            )
                            .contentShape(Rectangle())
                            .clipped()
                            .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                            
                        }
                        .frame(height: 280)
                        .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                        
                        HStack(alignment: .bottom) {
                            KFImage(URL(string: globalData.infoData!.poster))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 120, maxHeight: 180)
                                .cornerRadius(12)
                                .if(animation != nil) { view in
                                    // We only apply this background color if shouldApplyBackground is true
                                    view.matchedGeometryEffect(id: title, in: animation!)
                                }
                            
                            VStack(alignment: .leading) {
                                Text(globalData.infoData!.titles.secondary ?? "")
                                    .font(.caption)
                                    .fontWeight(.heavy)
                                    .opacity(0.7)
                                Text(globalData.infoData!.titles.primary)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(3)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(globalData.infoData!.status ?? "")
                                        .foregroundColor( Color(hex:
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
                                                               ))
                                        .fontWeight(.bold)
                                    
                                    Text("\(globalData.infoData!.totalMediaCount ?? 0) \(globalData.infoData!.mediaType)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                                .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, -60)
                        .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                    }
                    .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                }
                .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, alignment: .bottom)
                .offset(x: showHeader ? proxy.size.width/2 : -proxy.size.width/2)
                .animation(.spring(response: 0.3), value: showHeader)
                
                Spacer()
                    .frame(maxHeight: 70)
                
                LongText(text: globalData.infoData!.description, Colors: Colors)
                .padding(.horizontal, 20)
                .frame(maxWidth: proxy.size.width)
                .animation(.spring(response: 0.3), value: showFullDescription)
                
                VStack(alignment: .leading, spacing: 0) {
                    Toggle(isOn ? "Dubbed" : "Subbed", isOn: $isOn)
                        .toggleStyle(M3ToggleStyle(Colors: Colors))
                    
                    Text(globalData.infoData!.mediaType)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                    
                    if globalData.infoData!.seasons.count > 0 {
                        Dropdown(Colors: Colors, options: globalData.infoData!.seasons)
                            .zIndex(100)
                            .padding(.top, 12)
                    }
                }
                .padding(.horizontal, 20)
                .zIndex(100)
                
                if globalData.mediaFailedToLoad {
                    Text("Media Failed to load .-.\nTry again later.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 100)
                        .frame(maxWidth: proxy.size.width)
                } else if globalData.infoData!.mediaList.count > 0 && globalData.infoData!.mediaList[0].count > 0 {
                    EpisodeDisplay(proxy: proxy, Colors: Colors, navigating: $navigating)
                        .animation(.spring(response: 0.3), value: showFullDescription)
                        .padding(.horizontal, 20)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0...7, id: \.self) {index in
                                VStack(spacing: 0) {
                                    HStack(spacing: 8) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .frame(maxWidth: 150, minHeight: 90, maxHeight: 90)
                                            .redacted(reason: .placeholder)
                                            .shimmering()
                                        
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: proxy.size.width * 0.4, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                    
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: proxy.size.width * 0.3, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                }
                                            }
                                            Spacer()
                                            
                                            HStack {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.2, maxHeight: 12)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                                
                                                Spacer()
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.2, maxHeight: 12)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                            }
                                            .padding(.bottom, 6)
                                        }
                                        .padding(.trailing, 8)
                                        .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                    }
                                    VStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(maxWidth: .infinity, maxHeight: 14)
                                            .redacted(reason: .placeholder)
                                            .shimmering()
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(maxWidth: .infinity, maxHeight: 14)
                                            .redacted(reason: .placeholder)
                                            .shimmering()
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(maxWidth: .infinity, maxHeight: 14)
                                            .redacted(reason: .placeholder)
                                            .shimmering()
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(maxWidth: .infinity, maxHeight: 14)
                                            .redacted(reason: .placeholder)
                                            .shimmering()
                                    }
                                    .padding(12)
                                }
                                .background {
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
                                  ))
                                }
                                .cornerRadius(12)
                            }
                        }
                        .padding(.bottom, 60)
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    .frame(maxHeight: 700)
                }
            }
        }
    }
}
