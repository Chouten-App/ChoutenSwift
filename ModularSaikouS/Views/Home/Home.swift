//
//  Home.swift
//  ModularSaikouS
//
//  Created by Inumaki on 14.05.23.
//

import SwiftUI
import SwiftUIX
import Kingfisher
import ActivityIndicatorView

struct CarouselItem: View {
    let proxy: GeometryProxy
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {reader in
                FillAspectImage(
                    url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/141249-ssUG44UgGOMK.jpg"),
                    doesAnimateHorizontal: true
                )
                .blur(radius: 0.0)
                .overlay {
                    LinearGradient(stops: [
                        Gradient.Stop(color: Color("n1-900").opacity(0.9), location: 0.0),
                        Gradient.Stop(color: Color("n1-900").opacity(0.4), location: 1.0),
                    ], startPoint: .bottom, endPoint: .top)
                }
                .frame(
                    width: reader.size.width,
                    height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                    alignment: .center
                )
                .contentShape(Rectangle())
                .clipped()
                .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                
            }
            .frame(height: 380)
            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("文豪ストレイドッグス 第4シーズン")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("a1-300").opacity(0.7))
                    Text("Bungo Stray Dogs 4")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("a1-300"))
                }
                Text("Action • Comedy • Mystery • Supernatural")
                    .font(.headline)
                    .foregroundColor(Color("a2-100"))
                Text("The fourth season of *Bungou Stray Dogs*")
                    .font(.subheadline)
                    .foregroundColor(Color("a2-100").opacity(0.7))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, alignment: .bottomLeading)
            
        }
    }
}

struct Home: View {
    
    @State var htmlString = ""
    @State var jsString = ""
    @State var returnData: ReturnedData? = nil
    @State var currentCarouselIndex: Int = 0
    
    @StateObject var Colors = DynamicColors.shared
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if globalData.homeComponents.count > 0 {
                    ScrollView {
                        VStack {
                            PaginationView(axis: .horizontal) {
                                ForEach(0..<globalData.homeComponents[0].data.count, id: \.self) { index in
                                    OverlappingCard(image: globalData.homeComponents[0].data[currentCarouselIndex].image,proxy: proxy, Colors: Colors)
                                }
                            }
                            .currentPageIndex($currentCarouselIndex)
                            .frame(minHeight: 360,maxHeight: 360, alignment: .top)
                            .ignoresSafeArea()
                            .overlay(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(globalData.homeComponents[0].data[currentCarouselIndex].indicator ?? "")
                                            .foregroundColor(Color(hex:
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
                                                                  ))
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 3)
                                            .background {
                                                Capsule()
                                                    .fill(Color(hex:
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
                                        Spacer()
                                        Text(globalData.homeComponents[0].data[currentCarouselIndex].iconText ?? "")
                                            .fontWeight(.semibold)
                                        if globalData.homeComponents[0].data[currentCarouselIndex].showIcon {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color(hex:
                                                                        globalData.appearance == .system
                                                                       ? (
                                                                        colorScheme == .dark
                                                                        ? Colors.Tertiary.dark
                                                                        : Colors.Tertiary.light
                                                                       ) : (
                                                                        globalData.appearance == .dark
                                                                        ? Colors.Tertiary.dark
                                                                        : Colors.Tertiary.light
                                                                       )
                                                                      ))
                                        }
                                    }
                                    
                                    Text(globalData.homeComponents[0].data[currentCarouselIndex].titles.primary)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .lineLimit(3)
                                    if globalData.homeComponents[0].data[currentCarouselIndex].titles.secondary != nil {
                                        Text(globalData.homeComponents[0].data[currentCarouselIndex].titles.secondary!)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .opacity(0.7)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .top) {
                                        Text(globalData.homeComponents[0].data[currentCarouselIndex].subtitle)
                                        if globalData.homeComponents[0].data[currentCarouselIndex].subtitleValue.count > 0 {
                                            Text(globalData.homeComponents[0].data[currentCarouselIndex].subtitleValue.joined(separator: " • "))
                                                .fontWeight(.bold)
                                                .lineLimit(1)
                                        }
                                    }
                                    .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        NavigationLink(destination: Info(url: .constant(globalData.homeComponents[0].data[currentCarouselIndex].url), poster: .constant(globalData.homeComponents[0].data[currentCarouselIndex].image), title: .constant(globalData.homeComponents[0].data[currentCarouselIndex].titles.primary), showInfo: .constant(false), Colors: Colors)) {
                                            Text(globalData.homeComponents[0].data[currentCarouselIndex].buttonText)
                                                .foregroundColor(Color(hex:
                                                                        globalData.appearance == .system
                                                                       ? (
                                                                        colorScheme == .dark
                                                                        ? Colors.Tertiary.dark
                                                                        : Colors.Tertiary.light
                                                                       ) : (
                                                                        globalData.appearance == .dark
                                                                        ? Colors.Tertiary.dark
                                                                        : Colors.Tertiary.light
                                                                       )
                                                                      ))
                                                .fontWeight(.semibold)
                                                .contentShape(Rectangle())
                                        }
                                        .simultaneousGesture(TapGesture()
                                            .onEnded({ _ in
                                                globalData.infoData = nil
                                            }))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(Color(hex:
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
                                                                  ))
                                            .padding(6)
                                            .background {
                                                Circle()
                                                    .fill(Color(hex:
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
                                            }
                                    }
                                }
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
                                .padding(20)
                                .frame(maxWidth: .infinity, maxHeight: 220, alignment: .topLeading)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex:
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
                                                   ))
                                }
                                .shadow(radius: 12)
                                .padding(.horizontal, 12)
                                .offset(y: 100)
                            }
                            
                            VStack(alignment: .leading) {
                                ForEach(1..<globalData.homeComponents.count) { index in
                                    Text(globalData.homeComponents[index].title)
                                        .font(.title3)
                                        .fontWeight(.bold)
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
                                    
                                    if globalData.homeComponents[index].type == "list" {
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 12) {
                                                ForEach(0..<globalData.homeComponents[index].data.count) {listIndex in
                                                    NavigationLink(destination: Info(url: .constant(globalData.homeComponents[index].data[listIndex].url), poster: .constant(globalData.homeComponents[index].data[listIndex].image), title: .constant(globalData.homeComponents[index].data[listIndex].titles.primary), showInfo: .constant(false), Colors: Colors)) {
                                                        SearchCard(image: globalData.homeComponents[index].data[listIndex].image, title: globalData.homeComponents[index].data[listIndex].titles.primary, hasIndicator: globalData.homeComponents[index].data[listIndex].indicator != nil, indicatorText: globalData.homeComponents[index].data[listIndex].indicator ?? "", currentCount: globalData.homeComponents[index].data[listIndex].current, totalCount: globalData.homeComponents[index].data[listIndex].total, type: SearchCardType.GRID, cover: nil, Colors: Colors)
                                                    }
                                                    .simultaneousGesture(TapGesture()
                                                        .onEnded({ _ in
                                                            globalData.infoData = nil
                                                        }))
                                                }
                                            }
                                            .padding(.trailing, 20)
                                        }
                                        .frame(maxWidth: proxy.size.width)
                                        .padding(.trailing, -20)
                                    } else if globalData.homeComponents[index].type == "grid_2x" {
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: [
                                                GridItem(.flexible()),
                                                GridItem(.flexible())
                                            ], spacing: 12) {
                                                ForEach(0..<globalData.homeComponents[index].data.count) {gridIndex in
                                                    VStack {
                                                        NavigationLink(destination: Info(url: .constant(globalData.homeComponents[index].data[gridIndex].url), poster: .constant(globalData.homeComponents[index].data[gridIndex].image), title: .constant(globalData.homeComponents[index].data[gridIndex].titles.primary), showInfo: .constant(false), Colors: Colors)) {
                                                            KFImage(URL(string: globalData.homeComponents[index].data[gridIndex].image))
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(maxHeight: 280)
                                                                .cornerRadius(6)
                                                        }
                                                        .simultaneousGesture(TapGesture()
                                                            .onEnded({ _ in
                                                                globalData.infoData = nil
                                                            }))
                                                        
                                                        Text(globalData.homeComponents[index].data[gridIndex].titles.primary)
                                                            .frame(maxWidth: 80)
                                                            .font(.caption)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            .frame(maxHeight: 600)
                                            .padding(.trailing, 20)
                                        }
                                        .frame(maxWidth: proxy.size.width)
                                        .padding(.trailing, -20)
                                    } else if globalData.homeComponents[index].type == "grid_3x" {
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: [
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible())
                                            ], spacing: 12) {
                                                ForEach(0..<globalData.homeComponents[index].data.count) {gridIndex in
                                                    VStack {
                                                        NavigationLink(destination: Info(url: .constant(globalData.homeComponents[index].data[gridIndex].url), poster: .constant(globalData.homeComponents[index].data[gridIndex].image), title: .constant(globalData.homeComponents[index].data[gridIndex].titles.primary), showInfo: .constant(false), Colors: Colors)) {
                                                            KFImage(URL(string: globalData.homeComponents[index].data[gridIndex].image))
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(height: 160)
                                                                .frame(minHeight: 160, maxHeight: 160)
                                                                .cornerRadius(6)
                                                        }
                                                        .simultaneousGesture(TapGesture()
                                                            .onEnded({ _ in
                                                                globalData.infoData = nil
                                                            }))
                                                        
                                                        Text(globalData.homeComponents[index].data[gridIndex].titles.primary)
                                                            .frame(maxWidth: 80)
                                                            .font(.callout)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            .frame(minHeight: 600)
                                            .padding(.trailing, 20)
                                        }
                                        .frame(maxWidth: proxy.size.width)
                                        .padding(.trailing, -20)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 110)
                            .padding(.bottom, 110)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                } else {
                    VStack{
                        ActivityIndicatorView(isVisible: $globalData.isLoadingHomepage, type: .growingArc(Color(hex:
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
                                                                                                       ), lineWidth: 4)) .frame(width: 50.0, height: 50.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background {
            if htmlString.count > 0 && returnData != nil {
                WebView(htmlString: htmlString, javaScript: jsString, requestType: "home", enableExternalScripts: returnData!.allowExternalScripts, nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [], skips: [])), mediaConsumeBookData: .constant([]))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(
            Color(hex:
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
        .background {
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  )
            )
        }
        .onAppear {
            if globalData.newModule != nil {
                globalData.isLoadingHomepage = true
                htmlString = ""
                
                // get search js file data
                if returnData == nil {
                    returnData = moduleManager.getJsForType("home", num: 0)
                    
                    if returnData == nil {
                        globalData.isLoadingHomepage = false
                        return
                    }
                    
                    jsString = returnData!.js
                    
                    globalData.currentFileExecuted = "Home/code.js"
                }
                
                if returnData != nil {
                    if returnData!.request != nil {
                        Task {
                            let (data, response) = try await URLSession.shared.data(from: URL(string: returnData!.request!.url)!)
                            do {
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    
                                    let data = ["data": FloatyData(message: "Failed to load data from \(returnData!.request!.url)", error: true, action: nil)]
                                    NotificationCenter.default
                                        .post(name:           NSNotification.Name("floaty"),
                                              object: nil, userInfo: data)
                                    return
                                }
                                if returnData!.usesApi {
                                    let regexPattern = "&#\\d+;"
                                    let regex = try! NSRegularExpression(pattern: regexPattern)
                                    
                                    let range = NSRange(html.startIndex..., in: html)
                                    
                                    let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                    
                                    let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                    
                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                } else {
                                    htmlString = html
                                }
                            } catch let error {
                                (error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
