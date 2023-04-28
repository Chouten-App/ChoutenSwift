//
//  LogsDisplay.swift
//  ModularSaikouS
//
//  Created by Inumaki on 21.03.23.
//

import SwiftUI

struct LogsDisplay: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(0..<3) {index in
                    HStack {
                        Text("[14:32:46] :")
                            .fontWeight(.bold)
                        Text("This is a log.")
                            .lineLimit(6)
                            .padding(.leading, -5)
                    }
                }
                HStack {
                    Text("[14:32:46] :")
                        .fontWeight(.bold)
                    Text("This is an Error!")
                        .lineLimit(6)
                        .padding(.leading, -5)
                }
                .foregroundColor(Color("logsError"))
                ForEach(0..<3) {index in
                    HStack {
                        Text("[14:32:46] :")
                            .fontWeight(.bold)
                        Text("This is a log.")
                            .lineLimit(6)
                            .padding(.leading, -5)
                    }
                }
                HStack(alignment: .top) {
                    Text("[14:32:46] :")
                        .fontWeight(.bold)
                    Text("This is a way looooooooooooooooooooooonger log.")
                        .lineLimit(6)
                        .padding(.leading, -5)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: 500, alignment: .leading)
        .foregroundColor(Color("a2-100"))
        .background {
            Color("n1-900")
        }
    }
}

struct LogsDisplay_Previews: PreviewProvider {
    static var previews: some View {
        LogsDisplay()
    }
}
