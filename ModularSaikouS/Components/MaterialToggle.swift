//
//  MaterialToggle.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI

struct MaterialToggleStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(configuration.isOn ? Color(hex: "#5388C3") : Color("bg2"))
                    .frame(maxWidth: 38, maxHeight: 16)
                    .animation(.spring(response: 0.3), value: configuration.isOn)
                
                Circle()
                    .fill(configuration.isOn ? Color("accentColor1") : Color("accentColor1"))
                    .frame(maxWidth: 24, maxHeight: 24)
                    
                    .offset(x: configuration.isOn ? 8 :  -8)
                    .animation(.spring(response: 0.3), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
            
            configuration.label
                .font(.system(size: 16, weight: .bold))
                .padding(.leading, 12)
                .foregroundColor(Color("textColor2"))
        }
 
    }
}

struct MaterialToggle_Preview: PreviewProvider {
    @State var isOn: Bool = true
    static var previews: some View {
        VStack(alignment: .leading) {
            Toggle("Subbed", isOn: .constant(false))
                .toggleStyle(MaterialToggleStyle())
            Toggle("Dubbed", isOn: .constant(true))
                .toggleStyle(MaterialToggleStyle())
        }
        .padding(40)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color("bg")
        }
    }
}
