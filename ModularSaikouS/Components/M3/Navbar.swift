//
//  Navbar.swift
//  ModularSaikouS
//
//  Created by Inumaki on 20.04.23.
//

import SwiftUI

struct Navbar: View {
    @Binding var selectedTab: Int
    @StateObject var Colors = DynamicColors.shared
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            NavbarItem(label: "navitem-home", icon: "house.fill", selected: selectedTab == 0, hasNotification: false)
                .onTapGesture {
                    selectedTab = 0
                    globalData.showModuleSelector = false
                }
            NavbarItem(label: "navitem-search", icon: "magnifyingglass",selected: selectedTab == 1, hasNotification: false)
                .onTapGesture {
                    selectedTab = 1
                    globalData.showModuleSelector = false
                }
            NavbarItem(label: "navitem-history", icon: "clock.arrow.circlepath",selected: selectedTab == 2, hasNotification: true)
                .onTapGesture {
                    selectedTab = 2
                    globalData.showModuleSelector = false
                }
            NavbarItem(label: "navitem-more", icon: "ellipsis",selected: selectedTab == 3, hasNotification: false)
                .onTapGesture {
                    selectedTab = 3
                    globalData.showModuleSelector = false
                }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 24)
        .background(Color(hex: globalData.appearance == .system ? (colorScheme == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light) : (globalData.appearance == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light)))
        .shadow(color: .black.opacity(0.15),x: 0, y: 1, blur: 2)
        .shadow(color: .black.opacity(0.15),x: 0, y: 2, blur: 6)
    }
}

struct NavbarItem: View {
    let label: LocalizedStringKey
    let icon: String
    let selected: Bool
    let hasNotification: Bool
    @StateObject var Colors = DynamicColors.shared
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Capsule()
                    .fill(Color(hex: globalData.appearance == .system ? (colorScheme == .dark ? Colors.SecondaryContainer.dark : Colors.SecondaryContainer.light) : (globalData.appearance == .dark ? Colors.SecondaryContainer.dark : Colors.SecondaryContainer.light)))
                    .frame(maxWidth: 64, maxHeight: 32)
                    .opacity(selected ? 1.0 : 0.0)
                
                /*
                Circle()
                    .fill(Color("onSecondaryContainer"))
                    .frame(maxWidth: 12, maxHeight: 12)
                 */
                Image(systemName: icon)
                    .foregroundColor(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onSecondaryContainer.dark
                                : Colors.onSecondaryContainer.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onSecondaryContainer.dark
                                : Colors.onSecondaryContainer.light
                              )
                             )
                    )
                    .frame(maxWidth: 12, maxHeight: 12)
                    .contentShape(Rectangle())
                
                Text("3")
                    .font(.caption2)
                    .foregroundColor(
                        Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.onError.dark
                                : Colors.onError.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.onError.dark
                                : Colors.onError.light
                              )
                             )
                    )
                    .padding(4)
                    .background {
                        Circle()
                            .fill(
                                Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.Error.dark
                                        : Colors.Error.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.Error.dark
                                        : Colors.Error.light
                                      )
                                     )
                            )
                    }
                    .offset(x: 6, y: -6)
                    .opacity(hasNotification ? 1.0 : 0.0)
            }
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(
                    Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.onSecondaryContainer.dark
                            : Colors.onSecondaryContainer.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.onSecondaryContainer.dark
                            : Colors.onSecondaryContainer.light
                          )
                         )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Navbar(selectedTab: .constant(0))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background {
                Color("Surface")
            }
            .ignoresSafeArea()
            
            VStack {
                Navbar(selectedTab: .constant(0))
                    .environment(\.locale,
                                  Locale.init(identifier: "de"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background {
                Color("Surface")
            }
            .ignoresSafeArea()
        }
    }
}
