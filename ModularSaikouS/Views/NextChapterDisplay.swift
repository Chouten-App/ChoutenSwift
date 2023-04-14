//
//  NextChapterDisplay.swift
//  Saikou Beta
//
//  Created by Inumaki on 02.03.23.
//

import SwiftUI

struct NextChapterDisplay: View {
    let currentChapter: String
    let nextChapter: String
    let status: String
    
    var body: some View {
        ZStack {
            Color(.black)
            
            VStack {
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
                
                VStack {
                    
                    Text("NEXT UP")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(nextChapter)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                        .frame(maxHeight: 12)
                    
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 24))
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    Text(status)
                        .foregroundColor(status == "Ready" ? Color(hex: "#2B994A") : Color(hex: "#E5554C"))
                        .fontWeight(.semibold)
                    
                    Image(systemName: status == "Ready" ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(status == "Ready" ? Color(hex: "#2B994A") : Color(hex: "#E5554C"))
                    
                    Spacer()
                        .frame(maxHeight: 30)
                    
                    Text("Thanks to Mantton for the UI Idea")
                        .font(.system(size: 12))
                    
                }
                Spacer()
            }
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

