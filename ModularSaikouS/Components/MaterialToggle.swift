//
//  MaterialToggle.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI

struct MaterialToggleStyle: ToggleStyle {
    @StateObject var Colors = DynamicColors.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(configuration.isOn ?
                          Color(hex:
                                  globalData.appearance == .system
                                ? (
                                  colorScheme == .dark
                                  ? Colors.PrimaryContainer.dark
                                  : Colors.PrimaryContainer.light
                                ) : (
                                  globalData.appearance == .dark
                                  ? Colors.PrimaryContainer.dark
                                  : Colors.PrimaryContainer.light
                                )
                               ) :
                            Color(hex:
                                    globalData.appearance == .system
                                  ? (
                                    colorScheme == .dark
                                    ? Colors.SurfaceContainer.dark
                                    : Colors.SurfaceContainer.light
                                  ) : (
                                    globalData.appearance == .dark
                                    ? Colors.SurfaceContainer.dark
                                    : Colors.SurfaceContainer.light
                                  )
                                 )
                    )
                    .frame(maxWidth: 38, maxHeight: 16)
                    .animation(.spring(response: 0.3), value: configuration.isOn)
                
                Circle()
                    .fill(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.Primary.dark
                                : Colors.Primary.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.Primary.dark
                                : Colors.Primary.light
                              )
                             )
                    )
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
                .foregroundColor(
                    Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.onSurface.dark
                            : Colors.onSurface.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.onSurface.dark
                            : Colors.onSurface.light
                          )
                        )
                )
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color(hex: "#121316")
        }
        .ignoresSafeArea()
    }
}
