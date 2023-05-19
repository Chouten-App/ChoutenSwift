//
//  OpeningView.swift
//  Chouten
//
//  Created by Inumaki on 06.03.23.
//

import SwiftUI
import WebKit

struct OpeningView: View {
    @State var animationDone = false
    @State var navigate = false
    
    @StateObject var Colors = DynamicColors()
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Colors.Surface.dark
                )
                
                NavigationLink(destination: Main(Colors: Colors), isActive: $navigate) {
                    VStack {
                        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(40)
                            .padding(.horizontal, 120)
                            .frame(maxWidth: 400)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    print("navigating")
                                    navigate = true
                                }
                            }
                        
                        Text("CHOUTEN")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: Colors.onSurface.dark
                                            ))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .accentColor(Color(hex: Colors.Primary.dark))
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomLeading) {
            if globalData.showLogsButton {
                NavigationLink(destination: LogsDisplay()) {
                    Text("LOGS")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.horizontal, 24)
                        .frame(minWidth: 80, maxHeight: 56)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.SecondaryContainer.dark
                                            : Colors.SecondaryContainer.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.SecondaryContainer.dark
                                            : Colors.SecondaryContainer.light
                                          )
                                         )
                                )
                        }
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
                        .padding(.leading, 20)
                        .padding(.bottom, 120)
                        .foregroundColor(Color(hex:
                                                globalData.appearance == .system
                                               ? (
                                                colorScheme == .dark
                                                ? Colors.onPrimaryContainer.dark
                                                : Colors.onPrimaryContainer.light
                                               ) : (
                                                globalData.appearance == .dark
                                                ? Colors.onPrimaryContainer.dark
                                                : Colors.onPrimaryContainer.light
                                               )
                                              )
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}

