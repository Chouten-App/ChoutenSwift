//
//  NextChapterDisplay.swift
//  Saikou Beta
//
//  Created by Inumaki on 02.03.23.
//

import SwiftUI

enum readDirection {
    case rtl
    case ltr
    case vertical
}

struct NextChapterDisplay: View {
    let currentChapter: String
    let nextChapter: String
    let status: String
    
    @State var direction: readDirection = readDirection.rtl
    
    let errored = Color(hex: "#E5554C")
    let ready = Color(hex: "#2B994A")
    
    var body: some View {
        ZStack(alignment: direction == .rtl ? .leading : .trailing) {
            Color(.black)
            
            LinearGradient(stops: [Gradient.Stop(color: Color(hex: "#5a68c7").opacity(0.4), location: 0.0), Gradient.Stop(color: .clear, location: 1.0)], startPoint: direction == .rtl ? .leading : direction == .ltr ? .trailing : .bottom, endPoint: direction == .rtl ? .trailing : direction == .ltr ? .leading : .top)
                .frame(maxWidth: direction != .vertical ? 160 : .infinity, maxHeight: direction == .vertical ? 40 : .infinity)
            
            VStack {
                if direction != .vertical {
                    Spacer()
                    
                    Text("Chapter Complete")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(currentChapter)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Image("continueReading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 160)
                    
                    Spacer()
                }
                VStack {
                    Text("NEXT UP")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(nextChapter)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                        .frame(maxHeight: 30)
                    
                    Text("Thanks to Mantton for the UI Idea")
                        .font(.system(size: 12))
                    
                }
                if direction == .vertical {
                    Spacer()
                        .frame(maxHeight: 120)
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .ignoresSafeArea()
    }
}

struct NextChapterDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NextChapterDisplay(currentChapter: "Volume 1 Chapter 1", nextChapter: "Volume 1 Chapter 2", status: "Ready")
    }
}

