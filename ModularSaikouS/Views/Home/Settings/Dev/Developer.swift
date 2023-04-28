//
//  Developer.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI

struct Developer: View {
    @StateObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Text("Developer")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .center) {
                Spacer()
                
                Text("Nothing to see here yet .-.")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .foregroundColor(Color(hex: colorScheme == .dark ? Colors.onSurface.dark : Colors.onSurface.light))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            Color(hex: colorScheme == .dark ? Colors.Surface.dark : Colors.Surface.light)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Developer_Previews: PreviewProvider {
    static var previews: some View {
        Developer(Colors: DynamicColors())
    }
}
