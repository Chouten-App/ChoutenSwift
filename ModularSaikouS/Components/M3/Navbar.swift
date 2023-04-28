//
//  Navbar.swift
//  ModularSaikouS
//
//  Created by Inumaki on 20.04.23.
//

import SwiftUI

struct Navbar: View {
    @Binding var selectedTab: Int
    @ObservedObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            NavbarItem(label: "Home", icon: "house.fill", selected: selectedTab == 0, hasNotification: false, Colors: Colors)
                .onTapGesture {
                    selectedTab = 0
                }
            NavbarItem(label: "Search", icon: "magnifyingglass",selected: selectedTab == 1, hasNotification: false, Colors: Colors)
                .onTapGesture {
                    selectedTab = 1
                }
            NavbarItem(label: "Settings", icon: "gear",selected: selectedTab == 2, hasNotification: true, Colors: Colors)
                .onTapGesture {
                    selectedTab = 2
                }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 24)
        .background(Color(hex: colorScheme == .dark ? Colors.SurfaceContainer.dark : Colors.SurfaceContainer.light))
        .shadow(color: .black.opacity(0.15),x: 0, y: 1, blur: 2)
        .shadow(color: .black.opacity(0.15),x: 0, y: 2, blur: 6)
    }
}

struct NavbarItem: View {
    let label: String
    let icon: String
    let selected: Bool
    let hasNotification: Bool
    @ObservedObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Capsule()
                    .fill(Color(hex: colorScheme == .dark ? Colors.SecondaryContainer.dark : Colors.SecondaryContainer.light))
                    .frame(maxWidth: 64, maxHeight: 32)
                    .opacity(selected ? 1.0 : 0.0)
                
                /*
                Circle()
                    .fill(Color("onSecondaryContainer"))
                    .frame(maxWidth: 12, maxHeight: 12)
                 */
                Image(systemName: icon)
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSecondaryContainer.dark : Colors.onSecondaryContainer.light))
                    .frame(maxWidth: 12, maxHeight: 12)
                
                Text("3")
                    .font(.caption2)
                    .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onError.dark : Colors.onError.light))
                    .padding(4)
                    .background {
                        Circle()
                            .fill(Color(hex: colorScheme == .dark ? Colors.Error.dark : Colors.Error.light))
                    }
                    .offset(x: 6, y: -6)
                    .opacity(hasNotification ? 1.0 : 0.0)
            }
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSecondaryContainer.dark : Colors.onSecondaryContainer.light))
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Navbar(selectedTab: .constant(0), Colors: DynamicColors())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background {
            Color("Surface")
        }
        .ignoresSafeArea()
    }
}