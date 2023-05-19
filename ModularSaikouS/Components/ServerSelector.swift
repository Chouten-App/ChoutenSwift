//
//  ServerSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.05.23.
//

import SwiftUI

struct ServerSelector: View {
    var body: some View {
        VStack {
            ServerCard(selected: true)
            ServerCard(selected: false)
            ServerCard(selected: false)
        }
    }
}

struct ServerCard: View {
    let selected: Bool
    
    @StateObject var Colors = DynamicColors()
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Vidstreaming (Sub)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("MULTI QUALITY")
                    .font(.caption)
            }
            
            Spacer()
            
            Image(systemName: "arrow.down.to.line.compact")
                .fontSize(24)
        }
        .padding(16)
        .background {
            RoundedRectangle(12)
                .fill(
                    Color(hex:
                            !selected ?
                          (globalData.appearance == .system
                            ? (
                              colorScheme == .dark
                              ? Colors.OutlineVariant.dark
                              : Colors.OutlineVariant.light
                            ) : (
                              globalData.appearance == .dark
                              ? Colors.OutlineVariant.dark
                              : Colors.OutlineVariant.light
                            )
                          ) :
                            (globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.Secondary.dark
                            : Colors.Secondary.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.Secondary.dark
                            : Colors.Secondary.light
                          )
                         )
                         )
                )
        }
        .foregroundColor(
            Color(hex:
                    !selected ?
                  (globalData.appearance == .system
                    ? (
                      colorScheme == .dark
                      ? Colors.onSurface.dark
                      : Colors.onSurface.light
                    ) : (
                      globalData.appearance == .dark
                      ? Colors.onSurface.dark
                      : Colors.onSurface.light
                    )
                  ) :
                    (globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.onSecondary.dark
                    : Colors.onSecondary.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.onSecondary.dark
                    : Colors.onSecondary.light
                  )
                 )
                 )
        )
    }
}

struct ServerSelector_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ServerSelector()
                .padding(.leading, 64)
                .padding(.trailing, 16)
                .frame(maxWidth: 340, maxHeight: .infinity)
                .background {
                    Color(hex: DynamicColors().SurfaceContainer.dark)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color(hex: DynamicColors().Surface.dark)
        }
        .ignoresSafeArea()
    }
}
