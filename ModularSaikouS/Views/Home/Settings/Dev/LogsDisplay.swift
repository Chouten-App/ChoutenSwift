//
//  LogsDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 21.03.23.
//

import SwiftUI
import Kingfisher

struct LogsDisplay: View {
    
    @StateObject var Colors = DynamicColors.shared
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if globalData.logs.count > 0 {
                    ForEach(0..<globalData.logs.count) { index in
                        ZStack {
                            if globalData.logs[index].type == "error" {
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
                            } else {
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
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    KFImage(URL(string: globalData.logs[index].moduleIconPath))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 34)
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(
                                            globalData.logs[index].type == "error" ? "Error" :
                                                "Log"
                                        )
                                        .fontWeight(.bold)
                                        Text(globalData.logs[index].moduleName)
                                            .font(.caption)
                                            .opacity(0.7)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(globalData.logs[index].time)
                                        .font(.subheadline)
                                        .opacity(0.7)
                                }
                                
                                Text(globalData.logs[index].msg)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.leading)
                                
                                if globalData.logs[index].lines != nil {
                                    HStack {
                                        Spacer()
                                        
                                        Text("\(globalData.currentFileExecuted)(\(globalData.logs[index].lines!))")
                                            .font(.caption)
                                            .opacity(0.7)
                                    }
                                }
                            }
                            .padding(12)
                        }
                        .foregroundColor(
                            Color(hex:
                                    globalData.logs[index].type == "error" ?
                                  (globalData.appearance == .system
                                   ? (
                                    colorScheme == .dark
                                    ? Colors.onError.dark
                                    : Colors.onError.light
                                   ) : (
                                    globalData.appearance == .dark
                                    ? Colors.onError.dark
                                    : Colors.onError.light
                                   ))
                                  : (
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
                        )
                        .cornerRadius(16)
                    }
                }
            }
            .padding(.top, 110)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
        .overlay(alignment: .topLeading) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("Logs")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
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
                .frame(maxWidth: .infinity, maxHeight: (globalData.downloadedOnly || globalData.incognito ? 16 : 64) + 32, alignment: .bottomLeading)
                .background {
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
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                globalData.logs = []
            } label: {
                Image(systemName: "trash.fill")
                    .font(.title2)
                    .padding(12)
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
                    .background {
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
                        .cornerRadius(8)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 122)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct LogsDisplay_Previews: PreviewProvider {
    static var previews: some View {
        LogsDisplay()
    }
}
