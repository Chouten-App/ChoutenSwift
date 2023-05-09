//
//  Dropdown.swift
//  ModularSaikouS
//
//  Created by Inumaki on 06.05.23.
//

import SwiftUI

struct Dropdown: View {
    @StateObject var Colors: DynamicColors
    let options: [String]
    @StateObject var globalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedOption = 0
    
    @State var open: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.headline)
                
                Text("\(options[selectedOption])")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .scaleEffect(y: open ? -1 : 1)
            }
            .foregroundColor(Color(hex:
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
                                  ))
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)
            .background {
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
                .cornerRadius(8, corners: open ? [.topLeft, .topRight] : [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .animation(.spring(response: 0.3), value: open)
            }
            .onTapGesture {
                open.toggle()
            }
            .overlay(alignment: .top) {
                ScrollView {
                    VStack {
                        ForEach(0..<options.count) { index in
                            DropdownItem(Colors: Colors, option: options[index], selected: selectedOption == index)
                                .onTapGesture {
                                    selectedOption = index
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: CGFloat(options.count * 56 + 16))
                .frame(maxHeight: 400)
                .background(
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
                    .cornerRadius(4, corners: [.bottomLeft, .bottomRight])
                    .animation(.spring(response: 0.3), value: open)
                ).shadow(color: Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                      )
                                     ).opacity(0.08), radius: 2, x: 0, y: 0)
                .shadow(color: Color(hex:
                                        globalData.appearance == .system
                                     ? (
                                        colorScheme == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                     ) : (
                                        globalData.appearance == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                     )
                                    ).opacity(0.16), radius: 24, x: 0, y: 0)
                .scaleEffect(y: open ? 1 : 0, anchor: .top)
                .animation(.easeInOut(duration: 0.1), value: open)
                .padding(.top, 56)
            }
        }
        .foregroundColor(Color(hex:
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
                              ))
        .animation(.spring(response: 0.3), value: open)
    }
}

struct DropdownItem: View {
    @StateObject var Colors: DynamicColors
    let option: String
    var selected = false
    
    @StateObject var globalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text(option)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex:
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
                             ).opacity(selected ? 0.12 : 0.0))
    }
}

struct Dropdown_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Dropdown(Colors: DynamicColors(), options: ["Classic Series","Z Series","GT Series","Z Kai Series","Z Kai Series: Final","Super Series","Super Heroes Series"])
                .padding(.top, 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(hex: DynamicColors().Surface.dark))
    }
}
