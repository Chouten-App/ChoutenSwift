//
//  UrlPopup.swift
//  ModularSaikouS
//
//  Created by Inumaki on 14.04.23.
//

import SwiftUI

struct UrlPopup: View {
    @StateObject var Colors: DynamicColors
    @Binding var showPopup: Bool
    @State var fileUrl: String = ""
    
    @FocusState private var isFocused: Bool
    
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    func importModule() {
        guard let url = URL(string: fileUrl) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent.contains(".json") ? url.lastPathComponent : "\(url.lastPathComponent).json")
            
            print(fileURL)
            
            do {
                try data.write(to: fileURL)
                print("JSON data downloaded and saved to documents directory")
                showPopup = false
            } catch {
                print("Error saving JSON data: \(error.localizedDescription)")
                showPopup = false
            }
        }.resume()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Import Module")
                .font(.title2)
            
            TextField("", text: $fileUrl)
                .focused($isFocused)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(isFocused ? Color("a1-300") : Color("a2-100"))
                }
                .overlay(alignment: .leading) {
                    Text("Import Module from URL")
                        .font(isFocused ? .caption : .subheadline)
                        .background {
                            Color("n2-700")
                        }
                        .offset(y: isFocused ? -22 : 0)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            isFocused = true
                        }
                        .animation(.easeInOut, value: isFocused)
                }
            
            HStack {
                Spacer()
                
                Button {
                    importModule()
                } label: {
                    Text("Import Module")
                        .font(.subheadline)
                        .foregroundColor(Color("n1-700"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background {
                            Capsule()
                                .fill(Color("a1-300"))
                        }
                }
            }
        }
        .padding(20)
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
        .background(
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
        )
        .frame(maxWidth: 260, alignment: .leading)
        .cornerRadius(12)
    }
}

struct UrlPopup_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UrlPopup(Colors: DynamicColors(), showPopup: .constant(true))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: DynamicColors().Surface.dark))
    }
}
