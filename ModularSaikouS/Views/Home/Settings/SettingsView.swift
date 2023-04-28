//
//  SettingsView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Export Theme to JSON")
                            .fontWeight(.semibold)
                        Text("Copy your theme in JSON format")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light))
                            .opacity(0.7)
                            .frame(maxWidth: 14, maxHeight: 18)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light),lineWidth: 2)
                            .frame(maxWidth: 14, maxHeight: 18)
                            .offset(x: 4, y: -4)
                    }
                }
                .onTapGesture {
                    let json = Colors.getAsJson()
                    
                    print(json)
                    
                    UIPasteboard.general.setValue(json, forPasteboardType: "public.json")
                }
                
                NavigationLink(destination: Appearance(Colors: Colors)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Appearance")
                                .fontWeight(.semibold)
                            Text("Change the Colors of the app.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
                Button {
                    Colors.storeToJson()
                } label: {
                    Text("Save Theme to JSON.")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onPrimary.dark : Colors.onPrimary.light))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background {
                            Color(hex: colorScheme == .dark ? Colors.Primary.dark : Colors.Primary.light)
                                .cornerRadius(12)
                        }
                }
                
                Spacer()
                
                NavigationLink(destination: Developer(Colors: Colors)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Developer")
                                .fontWeight(.semibold)
                            Text("Only Dev Stuff. Dont Touch!")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
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
                .padding(.bottom, 120)
            }
            .padding(.horizontal, 20)
            .padding(.top, 80)
            .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light)
            }
            .ignoresSafeArea()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(Colors: DynamicColors())
    }
}
