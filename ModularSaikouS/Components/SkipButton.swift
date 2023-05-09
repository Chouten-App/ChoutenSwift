//
//  SkipButton.swift
//  ModularSaikouS
//
//  Created by Inumaki on 08.05.23.
//

import SwiftUI

struct SkipButton: View {
    @Binding var currentTime: Float
    @State var buttonOffset = 0.0
    @State var textWidth = 0.0
    
    var body: some View {
        Button(action: {
            buttonOffset = -textWidth + (textWidth * 0.5)
        }) {
            ZStack {
                Rectangle()
                    .fill(.black.opacity(0.4))
                
                Rectangle()
                    .fill(.white)
                    .offset(x: buttonOffset)
                    .onChange(of: currentTime) { currentTime in
                        //viewModel.showSkipButton(currentTime: currentTime)
                        /*let skipPercentage = getSkipPercentage(currentTime: currentTime, startTime: streamData.skips[0].start, endTime: streamData.skips[0].end)*/
                        withAnimation(.easeInOut(duration: 0.3)) {
                            buttonOffset = -textWidth + (textWidth * 0.5)
                        }
                    }
                
                
                Text("Skip Testing a longer text")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .blendMode(BlendMode.difference)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .overlay(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.textWidth = geometry.size.width
                                    buttonOffset = -textWidth
                                }
                        }
                    )
                
            }
            .fixedSize()
            .cornerRadius(12)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
        }
    }
}

struct SkipButton_Previews: PreviewProvider {
    static var previews: some View {
        SkipButton(currentTime: .constant(200.0))
    }
}
