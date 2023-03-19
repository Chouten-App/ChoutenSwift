//
//  ButtonLarge.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

struct ButtonLarge: View {
    
    var label: String
    var background: Color = .white
    var textColor: Color = .black.opacity(0.9)
    var action: (() -> ())
    
    let cornorRadius: CGFloat = 8
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(label)
                    .foregroundColor(textColor)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: cornorRadius)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .background(background)
        .cornerRadius(cornorRadius)
    }
}

struct ButtonLarge_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLarge(label: "Temp", action: {
            
        })
    }
}
