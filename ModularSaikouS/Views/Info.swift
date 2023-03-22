//
//  Info.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI
import Kingfisher

struct Info: View {
    
    @State var isOn: Bool = false
    
    var body: some View {
        GeometryReader {proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ZStack(alignment: .bottomLeading) {
                        GeometryReader {reader in
                            FillAspectImage(
                                url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg"),
                                doesAnimateHorizontal: proxy.size.width < 900
                            )
                            .overlay {
                                Color("bg").opacity(0.6)
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
                        .frame(height: 280)
                        
                        HStack(alignment: .bottom) {
                            KFImage(URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png"))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 120, maxHeight: 180)
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading) {
                                Text("ようこそ実力至上主義の教室へ")
                                    .font(.caption)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("textColor2").opacity(0.7))
                                Text("Classroom of the Elite")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor2"))
                                
                                Text("Completed")
                                    .foregroundColor(Color("accentColor1"))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 6)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, -40)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("12 Episodes")
                            .foregroundColor(Color("textColor2"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change.\n(Source: Anime News Network, edited)")
                            .foregroundColor(Color("textColor2").opacity(0.7))
                            .font(.subheadline)
                            .lineLimit(9)
                        
                        Text("see more")
                            .foregroundColor(Color("accentColor1"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Toggle(isOn ? "Dubbed" : "Subbed", isOn: $isOn)
                            .toggleStyle(MaterialToggleStyle())
                        
                        HStack(alignment: .bottom) {
                            Text("Episodes")
                                .foregroundColor(Color("accentColor1"))
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 6)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Source")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor2"))
                                    .padding(.trailing, 4)
                                    .padding(.bottom, -4)
                                
                                HStack {
                                    Text("Zoro.to")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background {
                                    Capsule()
                                        .fill(Color("accentColor1"))
                                }
                            }
                        }
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(0..<12) {index in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 8) {
                                            KFImage(URL(string: "https://www.themoviedb.org/t/p/w454_and_h254_bestv2/8A2eGfqyomNgxqcyfIexSmYF43C.jpg"))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(maxWidth: 150, maxHeight: 90)
                                                .cornerRadius(12)
                                            
                                            VStack(alignment: .leading) {
                                                Spacer()
                                                
                                                Text("What is evil? Whatever springs from weakness.")
                                                    .foregroundColor(Color("textColor2"))
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .lineLimit(2)
                                                
                                                Spacer()
                                                
                                                HStack {
                                                    Text("Episode 1")
                                                        .foregroundColor(Color("textColor2").opacity(0.7))
                                                        .font(.caption)
                                                        .fontWeight(.semibold)
                                                    
                                                    Spacer()
                                                    
                                                    Text("24 mins")
                                                        .foregroundColor(Color("textColor2").opacity(0.7))
                                                        .font(.caption)
                                                        .fontWeight(.semibold)
                                                }
                                                    .padding(.bottom, 6)
                                            }
                                            .padding(.trailing, 8)
                                            .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                        }
                                        
                                        Text("Melancholy, unmotivated Kiyotaka Ayanokouji attends his first day at Tokyo Metropoiltan Advanced Nurturing High School, a government-established institution for training a generation of Japan's best and brightest. In this school, it is said, everything is decided based on merit, which includes the generous monthly \"point\" allowance students can spend at local shops. As Ayanokouji begins navigating this system, he also nurtures curious relationships with aloof fellow outsider Suzune Horikita and the terminally gregarious Kikyou Kushida.")
                                            .font(.caption)
                                            .foregroundColor(Color("textColor2").opacity(0.7))
                                            .lineLimit(4)
                                            .padding(12)
                                    }
                                    .background {
                                        Color("bg2")
                                    }
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.top, 12)
                        .frame(maxHeight: 700)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("textColor"))
                    .padding(8)
                    .background {
                        Circle()
                            .fill(Color("accentColor1"))
                    }
            }
            .padding(.trailing, 30)
            .padding(.top, 70)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("bg")
        }
        .ignoresSafeArea()
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info()
    }
}
