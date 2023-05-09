//
//  More.swift
//  ModularSaikouS
//
//  Created by Inumaki on 04.05.23.
//

import SwiftUI

struct More: View {
    @StateObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var showAppearanceSelector: Bool = false
    @StateObject var globalData = GlobalData.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    /*
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.semibold)
                     */
                    
                    Text("頂点")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 40)
                    
                    VStack {
                        Button {
                            globalData.downloadedOnly.toggle()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Toggle Downloaded Only")
                                        .fontWeight(.semibold)
                                    Text("Sets the mode of the app to offline")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .opacity(0.7)
                                }
                                
                                Spacer()
                                
                                Toggle(isOn: $globalData.downloadedOnly, label: {})
                                    .toggleStyle(M3ToggleStyle(Colors: Colors))
                            }
                        }
                        
                        Button {
                            globalData.incognito.toggle()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Toggle Incognito Mode")
                                        .fontWeight(.semibold)
                                    Text("For the naughty naughty")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .opacity(0.7)
                                }
                                
                                Spacer()
                                
                                Toggle(isOn: $globalData.incognito, label: {})
                                    .toggleStyle(M3ToggleStyle(Colors: Colors))
                            }
                        }
                    }
                    
                    Divider()
                    
                    NavigationLink(destination: SettingsView(Colors: Colors)) {
                        HStack {
                            Image(systemName: "gear")
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text("Settings")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Image("coffee")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .onTapGesture {
                                if let url = URL(string: "https://www.buymeacoffee.com/inumaki") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        
                        Image("ko-fi")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .onTapGesture {
                                if let url = URL(string: "https://ko-fi.com/inumakicoding") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 80)
                .padding(.bottom, 120)
            }
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
                         ))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.Surface.dark
                            : Colors.Surface.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.Surface.dark
                            : Colors.Surface.light
                          )
                         )
            }
            .overlay {
                if showAppearanceSelector {
                    ZStack {
                        Color.black.opacity(0.4)
                        
                        AppearanceSelector(Colors: Colors, showSelector: $showAppearanceSelector)
                            .frame(width: 240)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        More(Colors: DynamicColors())
    }
}
