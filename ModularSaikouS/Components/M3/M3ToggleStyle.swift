//
//  M3ToggleStyle.swift
//  ModularSaikouS
//
//  Created by Inumaki on 04.05.23.
//

import SwiftUI

struct M3ToggleStyle: ToggleStyle {
    @StateObject var Colors: DynamicColors
    
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
                                  ? Colors.Primary.dark
                                  : Colors.Primary.light
                                ) : (
                                  globalData.appearance == .dark
                                  ? Colors.Primary.dark
                                  : Colors.Primary.light
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
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(configuration.isOn ?
                                  Color(hex:
                                          globalData.appearance == .system
                                        ? (
                                          colorScheme == .dark
                                          ? Colors.Outline.dark
                                          : Colors.Outline.light
                                        ) : (
                                          globalData.appearance == .dark
                                          ? Colors.Outline.dark
                                          : Colors.Outline.light
                                        )
                                       ).opacity(0.0) :
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Outline.dark
                                            : Colors.Outline.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Outline.dark
                                            : Colors.Outline.light
                                          )
                                         )
                                    , lineWidth: 2)
                    }
                    .frame(maxWidth: 52, minHeight: 32, maxHeight: 32)
                    .animation(.spring(response: 0.3), value: configuration.isOn)
                
                Circle()
                    .fill(
                        configuration.isOn ?
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onPrimary.dark
                                : Colors.onPrimary.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onPrimary.dark
                                : Colors.onPrimary.light
                              )
                             ) :
                            Color(hex:
                                    globalData.appearance == .system
                                  ? (
                                    colorScheme == .dark
                                    ? Colors.Outline.dark
                                    : Colors.Outline.light
                                  ) : (
                                    globalData.appearance == .dark
                                    ? Colors.Outline.dark
                                    : Colors.Outline.light
                                  )
                                 )
                    )
                    .frame(maxWidth: configuration.isOn ? 24 : 16, maxHeight: configuration.isOn ? 24 : 16)
                    
                    .offset(x: configuration.isOn ? 8 :  -8)
                    .animation(.spring(response: 0.3), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
            
            configuration.label
                .font(.system(size: 16, weight: .bold))
                .padding(.leading, 8)
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

struct M3ToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            Toggle("Subbed", isOn: .constant(false))
                .toggleStyle(M3ToggleStyle(Colors: DynamicColors()))
            Toggle("Dubbed", isOn: .constant(true))
                .toggleStyle(M3ToggleStyle(Colors: DynamicColors()))
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color(hex: "#121316")
        }
        .ignoresSafeArea()
    }
}
