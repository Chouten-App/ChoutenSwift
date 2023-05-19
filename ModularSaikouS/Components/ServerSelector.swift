//
//  ServerSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.05.23.
//

import SwiftUI

struct ServerData: Codable {
    let title: String
    let list: [Server]
}

struct ServerSelector: View {
    // TEMP
    @State var servers: [ServerData] = [
        ServerData(title: "Sub", list: [
            Server(name: "Vidstreaming", url: ""),
            Server(name: "Vidcloud", url: ""),
            Server(name: "Streamtape", url: ""),
        ]),
        ServerData(title: "Dub", list: [
            Server(name: "Vidstreaming", url: ""),
            Server(name: "Vidcloud", url: ""),
            Server(name: "Streamtape", url: ""),
        ]),
    ]
    
    @State var selectedServerData: Int = 0
    @State var selectedServer: Int = 0
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(0..<servers.count, id: \.self) { index in
                        Text(servers[index].title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            ForEach(0..<servers[index].list.count) { listIndex in
                                ServerCard(title: servers[index].list[listIndex].name, selected: selectedServerData == index && selectedServer == listIndex)
                                    .onTapGesture {
                                        selectedServerData = index
                                        selectedServer = listIndex
                                    }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
}

struct ServerCard: View {
    let title: String
    let selected: Bool
    
    @StateObject var Colors = DynamicColors()
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
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
                .padding(.trailing, 32)
                .frame(maxWidth: 350, maxHeight: .infinity)
                .background {
                    Color(hex: DynamicColors().SurfaceContainer.dark)
                }
                .overlay(alignment: .trailing) {
                    RoundedRectangle(4)
                        .fill(
                            Color(hex: DynamicColors().Outline.dark)
                        )
                        .frame(maxWidth: 4, maxHeight: 32)
                        .offset(x: -8)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color(hex: DynamicColors().Surface.dark)
        }
        .ignoresSafeArea()
    }
}
