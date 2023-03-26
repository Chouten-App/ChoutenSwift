//
//  FillAspectImage.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI
import Kingfisher

public struct FillAspectImage: View {
    let url: URL?
    
    let timer = Timer.publish(every: 25, on: .main, in: .common).autoconnect()
    @State private var finishedLoading: Bool = false
    @State private var imageWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var animLeft: Bool = false
    
    public init(url: URL?, doesAnimateHorizontal: Bool) {
        self.url = url
    }
    
    public var body: some View {
        GeometryReader { proxy in
            KFImage.url(url)
                .onSuccess { image in
                    finishedLoading = true
                }
                .onFailure { _ in
                    finishedLoading = true
                }
                .resizable()
                .scaledToFill()
                .transition(.opacity)
                .opacity(finishedLoading ? 1.0 : 0.0)
                .background(Color(white: 0.05))
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height,
                    alignment: .top
                )
                .contentShape(Rectangle())
                .onReceive(timer) {time in
                    animLeft.toggle()
                        if(animLeft) {
                            self.offset = (imageWidth / 2 - (proxy.size.width / 2))
                        } else {
                            self.offset = -(imageWidth / 2 - (proxy.size.width / 2))
                        }
                    
                }
                .clipped()
                .animation(.easeInOut(duration: 0.5), value: finishedLoading)
                
        }
    }
}

struct FillAspectImage_Previews: PreviewProvider {
    static var previews: some View {
        FillAspectImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg"), doesAnimateHorizontal: true)
            .frame(height: 400)
    }
}
