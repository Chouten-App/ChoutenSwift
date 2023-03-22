//
//  ThemePreview.swift
//  ModularSaikouS
//
//  Created by Inumaki on 20.03.23.
//

import SwiftUI

struct ThemePreview: View {
    let bgColor1: String
    let bgColor2: String
    let bgColor3: String
    let accentColor1: String
    let accentColor2: String
    let accentColor3: String
    let accentColor4: String
    let accentColor5: String
    
    
    var notSelectedBorderColor: String = "#494242"
    
    
    var body: some View {
        ZStack {
            Color(hex: bgColor1)
            
            GeometryReader {proxy in
                VStack {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: accentColor4))
                            .frame(maxWidth: proxy.size.width * 0.5, maxHeight: proxy.size.height * 0.1)
                        
                        ZStack(alignment: .topLeading) {
                            Color(hex: bgColor3)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(
                                                color: Color(hex: accentColor2),
                                                location: 0.0
                                            ),
                                            Gradient.Stop(
                                                color: Color(hex: accentColor2),
                                                location: 0.5
                                            ),
                                            Gradient.Stop(
                                                color: Color(hex: accentColor3),
                                                location: 0.5
                                            ),
                                            Gradient.Stop(
                                                color: Color(hex: accentColor3),
                                                location: 1.0
                                            ),
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(maxWidth: proxy.size.width * 0.2, maxHeight: proxy.size.height * 0.1)
                                .padding(8)
                                
                        }
                        .frame(maxWidth: proxy.size.width * 0.4, maxHeight: proxy.size.height * 0.34, alignment: .topLeading)
                        .cornerRadius(8)
                        
                    }
                    .padding(20)
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height * 0.8, alignment: .topLeading)
                    .background {
                        Color(hex: bgColor2)
                    }
                    
                    HStack {
                        Circle()
                            .fill(Color(hex: accentColor1))
                            .frame(maxWidth: proxy.size.height * 0.1)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: accentColor5))
                            .frame(maxWidth: proxy.size.width * 0.5, maxHeight: proxy.size.height * 0.1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .frame(maxHeight: proxy.size.height * 0.2, alignment: .center)
                }
            }
            
        }
        .frame(maxWidth: 140, maxHeight: 210)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: notSelectedBorderColor), lineWidth: 5)
        )
    }
}

struct ThemePreview_Previews: PreviewProvider {
    static var previews: some View {
        ThemePreview(bgColor1: "#44464f", bgColor2: "#1b1b1e", bgColor3: "#444346", accentColor1: "#a8c7ff", accentColor2: "#4fdf69", accentColor3: "#a8c7ff", accentColor4: "#e4e2e6", accentColor5: "#a4a3aa")
    }
}
