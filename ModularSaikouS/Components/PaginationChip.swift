//
//  PaginationChip.swift
//  ModularSaikouS
//
//  Created by Inumaki on 10.05.23.
//

import SwiftUI

struct PaginationChip: View {
    @Binding var paginationIndex: Int
    @Binding var startEpisodeList: Int
    @Binding var endEpisodeList: Int
    let episodeCount: Int
    let index: Int
    @StateObject var Colors = DynamicColors.shared
    var small: Bool = false
    @StateObject var globalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if index == paginationIndex {
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
            
            Text("\((50 * index) + 1) - " + String(50 + (50 * index) > episodeCount ? episodeCount : 50 + (50 * index)))
                .font(small ? .caption : nil)
                .fontWeight(.heavy)
                .padding(.vertical, small ? 4 : 6)
                .padding(.horizontal, small ? 8 : 12)
        }
        .foregroundColor(
            index == paginationIndex ? Color(hex:
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
                )
            : Color(hex:
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
        .fixedSize()
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    Color(hex:
                                globalData.appearance == .system
                              ? (
                                colorScheme == .dark
                                ? Colors.Outline.dark
                                : Colors.Outline.light
                              ) : (
                                globalData.appearance == .dark
                                ? Colors.Outline.dark
                                : Colors.Outline.light
                              )
                        ).opacity(0.7), lineWidth: index == paginationIndex ? 0 : 1)
        )
        .onTapGesture {
            self.startEpisodeList = 50 * index
            self.endEpisodeList = 50 + (50 * index) > episodeCount ? episodeCount : 50 + (50 * index)
            self.paginationIndex = index
        }
    }
}

struct PaginationChip_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            PaginationChip(paginationIndex: .constant(0), startEpisodeList: .constant(1), endEpisodeList: .constant(50), episodeCount: 50, index: 0)
            PaginationChip(paginationIndex: .constant(0), startEpisodeList: .constant(51), endEpisodeList: .constant(100), episodeCount: 200, index: 1)
            PaginationChip(paginationIndex: .constant(0), startEpisodeList: .constant(101), endEpisodeList: .constant(151), episodeCount: 200, index: 2)
        }
    }
}
