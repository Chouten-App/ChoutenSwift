//
//  ButtonLarge.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI
import Kingfisher

struct ButtonLarge: View {
    @StateObject var Colors: DynamicColors
    var label: String
    var image: String?
    var developer: String?
    var version: String?
    var isSelected: Bool = false
    var background: Color = Color(hex: "#ffcb3d")
    var textColor: Color = Color(hex: "#000000")
    var action: (() -> ())
    
    let cornorRadius: CGFloat = 12
    
    @StateObject var globalData = GlobalData.shared
    @Environment(\.colorScheme) var colorScheme
    
    @State var showDetails = false
    @State var shouldAutoUpdate = false
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    if image != nil {
                        KFImage(URL(string: image!))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: showDetails ? 52 : 40, maxWidth: showDetails ? 52 : 40, minHeight: showDetails ? 52 : 40, maxHeight: showDetails ? 52 : 40)
                            .cornerRadius(12)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex:
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
                                                 ), lineWidth: 1)
                            }
                    } else {
                        ZStack {
                            Color(.white).opacity(0.6)
                                .blur(radius: 6)
                            
                            Image(systemName: "questionmark")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 14)
                                .foregroundColor(Color("n1-700"))
                        }
                        .fixedSize()
                        .cornerRadius(40)
                        
                    }
                    
                    VStack(alignment: .leading) {
                        Text(label)
                            .foregroundColor(textColor)
                            .font(.system(size: showDetails ? 20 : 16, weight: .bold))
                            .lineLimit(1)
                        
                        HStack {
                            Text(developer ?? "Unknown")
                                .foregroundColor(textColor.opacity(0.7))
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                            if version != nil {
                                Text("v\(version!)")
                                    .foregroundColor(textColor.opacity(0.7))
                                    .font(.system(size: 12, weight: .semibold))
                            }
                        }
                    }
                    .padding(.top, showDetails ? 6 : 0)
                    .frame(minHeight: 52, alignment: showDetails ? .top : .center)
                    
                    Spacer()
                    
                    Button {
                        /*
                         do {
                         try FileManager.default.removeItem(at: fileurl)
                         } catch let error {
                         print(error)
                         }
                         */
                        withAnimation(.spring(response: 0.3)) {
                            showDetails.toggle()
                        }
                    } label: {
                        Image(systemName: showDetails ? "xmark" : "info")
                            .foregroundColor(
                                Color(hex:
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
                            )
                            .padding(10)
                            .background {
                                Circle()
                                    .fill(
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
                                    )
                            }
                    }
                }
                Text("A Module to get Anime from Zoro.to, with softsubs")
                    .fontWeight(.semibold)
                    .foregroundColor(textColor.opacity(0.7))
                
                HStack {
                    Text("Auto update Module")
                        .font(.subheadline)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    
                    Toggle(isOn: $shouldAutoUpdate, label: {})
                        .toggleStyle(M3ToggleStyle(Colors: Colors))
                }
                
            }
            .padding(.top, showDetails ? 20 : 0)
            .padding(.horizontal, 20)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: showDetails ? 180 : 52, maxHeight: showDetails ? 180 : 52, alignment: .topLeading)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: showDetails ? 180 : 52, maxHeight: showDetails ? 180 : 52, alignment: .topLeading)
        .buttonStyle(PlainButtonStyle())
        .background(background)
        .cornerRadius(cornorRadius)
        .overlay {
            RoundedRectangle(cornerRadius: cornorRadius)
                .stroke(background.colorInvert(), lineWidth: isSelected ? 2 : 0)
                .hueRotation(.degrees(30))
        }
    }
}

struct ButtonLarge_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonLarge(Colors: DynamicColors(), label: "Zoro.to", image: "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/qe7kzhh0bo1qt9ohrxwb", developer: "Inumaki", version: "0.1.0", action: {
                
            })
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color(hex: DynamicColors().Surface.dark)
        }
        .ignoresSafeArea()
    }
}
