//
//  ButtonLarge.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI
import Kingfisher

struct ButtonLarge: View {
    var fileurl: URL
    var label: String
    var image: String?
    var developer: String?
    var version: String?
    var background: Color = Color("accentColor1")
    var textColor: Color = Color("textColor")
    var action: (() -> ())
    
    let cornorRadius: CGFloat = 12
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if image != nil {
                    KFImage(URL(string: image!))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 40, maxWidth: 40, minHeight: 40, maxHeight: 40)
                        .cornerRadius(40)
                } else {
                    ZStack {
                        Color(.white).opacity(0.6)
                            .blur(radius: 6)
                        
                        Image(systemName: "questionmark")
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .foregroundColor(Color("textColor"))
                    }
                    .fixedSize()
                    .cornerRadius(40)
                    
                }
                
                VStack(alignment: .leading) {
                    Text(label)
                        .foregroundColor(textColor)
                        .font(.system(size: 16, weight: .bold))
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
                .frame(minHeight: 120)
                
                Spacer()
                
                Button {
                    print(fileurl)
                    do {
                        try FileManager.default.removeItem(at: fileurl)
                    } catch let error {
                        print(error)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color(hex: "#f3767b"))
                        }
                }
            }
            .padding(.horizontal, 20)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .background(background)
        .cornerRadius(cornorRadius)
    }
}

struct ButtonLarge_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLarge(fileurl: URL(string: "")!, label: "Zoro.to", action: {
            
        })
        .frame(maxHeight: 52)
        .padding(.horizontal, 20)
    }
}
