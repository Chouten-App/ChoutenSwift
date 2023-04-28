//
//  SearchCard.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import Kingfisher
import Shimmer

enum SearchCardType {
    case GRID
    case LIST
}

struct SearchCard: View {
    let image: String
    let title: String
    let hasIndicator: Bool
    let indicatorText: String?
    let currentCount: Int?
    let totalCount: Int?
    
    let type: SearchCardType
    let cover: String?
    
    @ObservedObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    var animation: Namespace.ID?
    
    var body: some View {
        if type == .GRID {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    KFImage(URL(string: image))
                        .placeholder {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(minWidth: 110, maxWidth: 110, minHeight: 160, maxHeight: 160)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 110, maxWidth: 110, minHeight: 160, maxHeight: 160)
                        .cornerRadius(12)
                        /*
                        .if(animation != nil) { view in
                            // We only apply this background color if shouldApplyBackground is true
                            view.matchedGeometryEffect(id: title, in: animation!)
                        }*/
                    
                    if hasIndicator {
                        Text(indicatorText!)
                            .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimary.dark : Colors.onPrimary.light))
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                            .padding(.leading, 8)
                            .padding(.trailing, 12)
                            .padding(.top, 4)
                            .background {
                                Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light)
                            }
                            .cornerRadius(6)
                            .offset(x: 6, y: -4)
                        
                    }
                }
                .cornerRadius(12)
                .clipped()
                .frame(minWidth: 110, maxWidth: 110, minHeight: 160, maxHeight: 160)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 110)
                    .lineLimit(2)
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                    .frame(minWidth: 110, maxWidth: 110)
                    .multilineTextAlignment(.leading)
                
                Text((currentCount != nil ? String(currentCount!) : "~") + " | " + (totalCount != nil ? String(totalCount!) : "~"))
                    .font(.caption)
                    .frame(maxWidth: 104, alignment: .trailing)
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light).opacity(0.7))
            }
        } else {
            GeometryReader {proxy in
                ZStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        KFImage(URL(string: cover ?? image)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: proxy.size.width, minHeight: 110, maxHeight: 110)
                            .overlay {
                                Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light)
                                    .opacity(0.4)
                            }
                        
                        Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light)
                            .frame(maxWidth: proxy.size.width, minHeight: 80, maxHeight: 80)
                    }
                    
                    HStack {
                        KFImage(URL(string: image)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 80, maxHeight: 120)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading) {
                            Text("Classroom of the Elite")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
                                .lineLimit(2)
                            
                            HStack(alignment: .top) {
                                Text("\(currentCount ?? 0) / \(totalCount ?? 0)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light).opacity(0.7))
                                
                                Spacer()
                                
                                Text("Drama • Psychological")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light).opacity(0.7))
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120, alignment: .bottom)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: proxy.size.width, minHeight: 190, maxHeight: 190, alignment: .bottomLeading)
                }
                .cornerRadius(20)
            }
        }
    }
}

struct SearchCard_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            SearchCard(image: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png", title: "Classroom of the Elite", hasIndicator: true, indicatorText: "DUB", currentCount: 7, totalCount: 12, type: .LIST, cover: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg", Colors: DynamicColors())
                .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background {
            Color("n1-900")
        }
    }
}
