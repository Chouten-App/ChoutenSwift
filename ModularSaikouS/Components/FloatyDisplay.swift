//
//  FloatyDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 20.04.23.
//

import SwiftUI

struct FloatyAction {
    let actionTitle: String
    let action: (() -> Void)
}

struct FloatyDisplay: View {
    @StateObject var Colors: DynamicColors
    @Binding var message: String
    @Binding var error: Bool
    var action: FloatyAction? = nil
    @Binding var showFloaty: Bool
    
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(
                    error ? Color(hex:
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
                                 ) : Color(hex:
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
                .lineLimit(8)
                .onTapGesture {
                    UIPasteboard.general.setValue(message, forPasteboardType: "public.plain-text")
                }
            Spacer()
            if action != nil {
                Text(action!.actionTitle)
                    .padding(8)
                    .onTapGesture(perform: action!.action)
                    .foregroundColor(error ? Color(hex:
                                                    globalData.appearance == .system
                                                  ? (
                                                    colorScheme == .dark
                                                    ? Colors.onErrorContainer.dark
                                                    : Colors.onErrorContainer.light
                                                  ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.onErrorContainer.dark
                                                    : Colors.onErrorContainer.light
                                                  )
                                                 ) : Color(hex:
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
                                         ))
            }
            if action == nil {
                Image(systemName: "xmark")
                    .foregroundColor(error ? Color(hex:
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
                                                 ) : Color(hex:
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
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        showFloaty = false
                    }
            }
        }
        .padding(16)
        .background(error ? Color(hex:
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
                                 ).cornerRadius(12) : Color(hex:
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
                         ).cornerRadius(12))
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
        .padding(.horizontal, 16)
    }
}

struct FloatyDisplay_Previews: PreviewProvider {
    static var previews: some View {
        FloatyDisplay(Colors: DynamicColors(), message: .constant("Floaty"), error: .constant(false), showFloaty: .constant(true))
    }
}
