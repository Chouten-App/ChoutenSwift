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
    var body: some View {
        KFImage(URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx145139-rRimpHGWLhym.png"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: proxy.size.width, maxHeight: 360)
            .clipped()
            .cornerRadius([.bottomLeading, .bottomTrailing], 12)
            .overlay {
                LinearGradient(stops: [Gradient.Stop(color: .clear, location: 0.0), Gradient.Stop(color: Color("bg"), location: 1.0)], startPoint: .top, endPoint: .bottom)
                    .cornerRadius(10)
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
    }
}

struct OverlappingCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {proxy in
            VStack {
                PaginationView {
                    OverlappingCard(proxy: proxy)
                    OverlappingCard(proxy: proxy)
                    OverlappingCard(proxy: proxy)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .background(Color("bg"))
    }
}
