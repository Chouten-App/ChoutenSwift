//
//  LongText.swift
//  ModularSaikouS
//
//  Created by Inumaki on 06.05.23.
//

import SwiftUI
import PureSwiftUI

struct LongText: View {
    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false

    let text: String
    @StateObject var Colors = DynamicColors.shared

    @State var lineLimit = 9
    
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            // Render the real text (which might or might not be limited)
            Text(text)
                .font(.subheadline)
                .lineLimit(expanded ? nil : lineLimit)
                .opacity(0.7)
                .animation(.spring(response: 0.3), value: expanded)
                .geometryReader { textSize in
                    self.truncated = textSize.size.height >= 78
                }

            if truncated { toggleButton }
        }
    }

    var toggleButton: some View {
        Button(action: { self.expanded.toggle() }) {
            Text("See \(self.expanded ? "less" : "more")")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top, 4)
                .foregroundColor(Color(hex:
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
                                      ))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .animation(.spring(response: 0.3), value: self.expanded)
        }
    }
}

struct LongText_Previews: PreviewProvider {
    static var previews: some View {
        LongText(text: "Based on a world-famous action RPG set in an open world, Dragon's Dogma from Capcom will be brought to life as a Netflix original anime series. The story follows a man's journey seeking revenge on a dragon who stole his heart. On his way, the man is brought back to life as an \"Arisen.\" An action adventure about a man challenged by demons who represent the seven deadly sins of humans. (Source: Netflix)")
            .padding(.horizontal, 20)
    }
}
