//
//  InfoDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.04.23.
//

import SwiftUI
import Kingfisher

struct InfoDisplay: View {
    @StateObject var globalData: GlobalData
    @StateObject var Colors: DynamicColors
    
    let proxy: GeometryProxy
    @Binding var showHeader: Bool
    let title: String
    @Binding var showFullDescription: Bool
    @Binding var isOn: Bool
    @Binding var navigating: Bool
    var animation: Namespace.ID?
    
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: 0) {
                ZStack {
                    Color(hex: colorScheme == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light)
                    
                    Text(globalData.infoData!.titles.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
                .padding(12)
                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimaryContainer.dark : Colors.onPrimaryContainer.light))
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
                                Gradient.Stop(color: Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light).opacity(0.9), location: 0.0),
                                Gradient.Stop(color: Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light).opacity(0.4), location: 1.0),
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
                                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
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
            
            VStack(alignment: .leading) {
                Text(globalData.infoData!.description)
                    .font(.subheadline)
                    .lineLimit(showFullDescription ? nil : 9)
                    .opacity(0.7)
                    .animation(.spring(response: 0.3), value: showFullDescription)
                
                Text("See \(showFullDescription ? "less" : "more")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .animation(.spring(response: 0.3), value: showFullDescription)
                    .onTapGesture {
                        showFullDescription.toggle()
                    }
            }
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.3), value: showFullDescription)
            
            VStack(alignment: .leading) {
                Toggle(isOn ? "Dubbed" : "Subbed", isOn: $isOn)
                    .toggleStyle(MaterialToggleStyle(Colors: Colors))
                
                Text(globalData.infoData!.mediaType)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                
                if globalData.infoData!.seasons.count > 0 {
                    HStack {
                        Image(systemName: "folder.fill")
                            .font(.subheadline)
                        
                        Text(globalData.infoData!.seasons[0])
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimary.dark : Colors.onPrimary.light))
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, maxHeight: 42, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 20)
            
            EpisodeDisplay(proxy: proxy, globalData: globalData, Colors: Colors, navigating: $navigating)
                .animation(.spring(response: 0.3), value: showFullDescription)
                .padding(.horizontal, 20)
        }
    }
}

struct InfoDisplay_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {proxy in
            InfoDisplay(globalData: GlobalData(), Colors: DynamicColors(), proxy: proxy, showHeader: .constant(false), title: "", showFullDescription: .constant(false), isOn: .constant(false), navigating: .constant(false))
        }
    }
}
