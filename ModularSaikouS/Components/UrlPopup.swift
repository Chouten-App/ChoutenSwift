//
//  UrlPopup.swift
//  ModularSaikouS
//
//  Created by Inumaki on 14.04.23.
//

import SwiftUI

struct UrlPopup: View {
    @Binding var showPopup: Bool
    @State var fileUrl: String = ""
    
    @FocusState private var isFocused: Bool
    
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
                    .fill(isFocused ? Color("accentColor1") : Color("textColor2"))
            }
            .overlay(alignment: .leading) {
                Text("Import Module from URL")
                    .font(isFocused ? .caption : .subheadline)
                    .background {
                        Color("bg2")
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
                        .foregroundColor(Color("textColor"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background {
                            Capsule()
                                .fill(Color("accentColor1"))
                        }
                }
            }
        }
        .padding(20)
        .foregroundColor(Color("textColor2"))
        .background(Color("bg2"))
        .frame(maxWidth: 260, alignment: .leading)
        .cornerRadius(12)
    }
}

struct UrlPopup_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UrlPopup(showPopup: .constant(true))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg"))
    }
}
