//
//  FloatyDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 20.04.23.
//

import SwiftUI

struct FloatyAction {
    let actionTitle: String
    let action: (() -> Void)
}

struct FloatyDisplay: View {
    @Binding var message: String
    var action: FloatyAction? = nil
    @Binding var showFloaty: Bool
    
    init(message: Binding<String>, showFloaty: Binding<Bool>, action: FloatyAction? = nil) {
        self._message = message
        self._showFloaty = showFloaty
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(Color("InverseOnSurface"))
                .lineLimit(8)
                .onTapGesture {
                    UIPasteboard.general.setValue(message, forPasteboardType: "public.plain-text")
                }
            Spacer()
            if action != nil {
                Text(action!.actionTitle)
                    .padding(8)
                    .onTapGesture(perform: action!.action)
                    .foregroundColor(Color("InverseOnSurface"))
            }
            if action == nil {
                Image(systemName: "xmark")
                    .foregroundColor(Color("InversePrimary"))
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        showFloaty = false
                    }
            }
        }
        .padding(16)
        .background(Color("InverseSurface").cornerRadius(12))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 16)
    }
}

struct FloatyDisplay_Previews: PreviewProvider {
    static var previews: some View {
        FloatyDisplay(message: .constant("Floaty"), showFloaty: .constant(true))
    }
}
