//
//  Info.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI
import Kingfisher
import Shimmer
import SwiftUIX
import PureSwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct Info: View {
    @Binding var url: String
    @Binding var poster: String
    @Binding var title: String
    @Binding var showInfo: Bool
    @StateObject var Colors = DynamicColors.shared
    var animation: Namespace.ID?
    @StateObject var viewModel: InfoViewModel = InfoViewModel()
    @State var isOn: Bool = false
    @State var showFullDescription: Bool = false
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @State var returnData: ReturnedData? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showHeader: Bool = false
    @State var showRealHeader: Bool = false
    @State var nextUrl: String = ""
    @State var currentJsIndex = 0
    
    @State var navigating: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
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
            
            GeometryReader {proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    if globalData.infoData != nil {
                        InfoDisplay(Colors: Colors, proxy: proxy, showHeader: $showHeader, title: title, showFullDescription: $showFullDescription, isOn: $isOn, navigating: $navigating, htmlString: $viewModel.htmlString, jsString: $viewModel.jsString, currentJsIndex: $currentJsIndex)
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
                            .frame(maxWidth: proxy.size.width)
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewOffsetKey.self,
                                                       value: -$0.frame(in: .named("infoscroll")).origin.y)
                            })
                            .onPreferenceChange(ViewOffsetKey.self) {
                                if($0 >= 110 && $0 < 230) {
                                    showHeader = true
                                    showRealHeader = false
                                } else if($0 >= 230) {
                                    showHeader = true
                                    showRealHeader = true
                                } else {
                                    showHeader = false
                                    showRealHeader = false
                                }
                            }
                    }
                    else {
                        VStack(alignment: .leading) {
                            
                            HStack(alignment: .bottom, spacing: 0) {
                                HStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.7, maxHeight: 20)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                }
                                .padding(12)
                                .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, maxHeight: 110, alignment: .bottomLeading)
                                .background {
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
                                .padding(.bottom, -60)
                                
                                
                                ZStack(alignment: .bottomLeading) {
                                    GeometryReader {reader in
                                        Rectangle()
                                            .overlay {
                                                LinearGradient(stops: [
                                                    Gradient.Stop(color: Color(hex:
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
                                                                              ).opacity(0.9), location: 0.0),
                                                    Gradient.Stop(color: Color(hex:
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
                                                                              ).opacity(0.4), location: 1.0),
                                                ], startPoint: .bottom, endPoint: .top)
                                            }
                                            .frame(
                                                width: reader.size.width,
                                                height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                                                alignment: .top
                                            )
                                            .contentShape(Rectangle())
                                            .clipped()
                                            .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                                    }
                                    .frame(height: 280)
                                    .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                                    HStack(alignment: .bottom) {
                                        KFImage(URL(string: poster))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 120, maxHeight: 180)
                                            .cornerRadius(12)
                                            .if(animation != nil) { view in
                                                view.matchedGeometryEffect(id: title, in: animation!, isSource: false)
                                            }
                                        
                                        VStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(maxWidth: proxy.size.width * 0.4, maxHeight: 14)
                                                .redacted(reason: .placeholder)
                                                .shimmering()
                                            VStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.3, maxHeight: 20)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.5, maxHeight: 20)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.25, maxHeight: 16)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(maxWidth: proxy.size.width * 0.2, maxHeight: 14)
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 8)
                                            .padding(.top, 4)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, -60)
                                    .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                                }
                                .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width)
                            }
                            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, alignment: .bottom)
                            .offset(x: showHeader ? proxy.size.width/2 : -proxy.size.width/2)
                            .animation(.spring(response: 0.3), value: showHeader)
                            
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.8, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.7, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.8, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.8, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.7, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.8, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.4, maxHeight: 14)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                    
                                }
                                
                                
                                Toggle(isOn ? "Dubbed" : "Subbed", isOn: $isOn)
                                    .toggleStyle(MaterialToggleStyle(Colors: Colors))
                                
                                HStack(alignment: .bottom) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(maxWidth: proxy.size.width * 0.25, maxHeight: 20)
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                        .padding(.bottom, 6)
                                    
                                    Spacer()
                                    
                                    /*
                                     VStack(alignment: .trailing) {
                                     Text("Source")
                                     .font(.subheadline)
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
                                     .padding(.trailing, 4)
                                     .padding(.bottom, -4)
                                     
                                     HStack {
                                     Text("Zoro.to")
                                     .font(.subheadline)
                                     .fontWeight(.semibold)
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
                                     
                                     Image(systemName: "chevron.down")
                                     .font(.caption)
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
                                     }
                                     .padding(.vertical, 8)
                                     .padding(.horizontal, 20)
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
                                     ))
                                     }
                                     }
                                     */
                                }
                                
                                ScrollView {
                                    VStack(spacing: 20) {
                                        ForEach(0...7, id: \.self) {index in
                                            VStack(spacing: 0) {
                                                HStack(spacing: 8) {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .frame(maxWidth: 150, minHeight: 90, maxHeight: 90)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                    
                                                    VStack(alignment: .leading) {
                                                        Spacer()
                                                        
                                                        HStack {
                                                            VStack(alignment: .leading) {
                                                                RoundedRectangle(cornerRadius: 4)
                                                                    .frame(maxWidth: proxy.size.width * 0.4, maxHeight: 14)
                                                                    .redacted(reason: .placeholder)
                                                                    .shimmering()
                                                                
                                                                RoundedRectangle(cornerRadius: 4)
                                                                    .frame(maxWidth: proxy.size.width * 0.3, maxHeight: 14)
                                                                    .redacted(reason: .placeholder)
                                                                    .shimmering()
                                                            }
                                                        }
                                                        Spacer()
                                                        
                                                        HStack {
                                                            RoundedRectangle(cornerRadius: 4)
                                                                .frame(maxWidth: proxy.size.width * 0.2, maxHeight: 12)
                                                                .redacted(reason: .placeholder)
                                                                .shimmering()
                                                            
                                                            Spacer()
                                                            
                                                            RoundedRectangle(cornerRadius: 4)
                                                                .frame(maxWidth: proxy.size.width * 0.2, maxHeight: 12)
                                                                .redacted(reason: .placeholder)
                                                                .shimmering()
                                                        }
                                                        .padding(.bottom, 6)
                                                    }
                                                    .padding(.trailing, 8)
                                                    .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                                }
                                                VStack {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: .infinity, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: .infinity, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: .infinity, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .frame(maxWidth: .infinity, maxHeight: 14)
                                                        .redacted(reason: .placeholder)
                                                        .shimmering()
                                                }
                                                .padding(12)
                                            }
                                            .background {
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
                                                      ))
                                            }
                                            .cornerRadius(12)
                                        }
                                    }
                                    .padding(.bottom, 60)
                                }
                                .padding(.top, 12)
                                .frame(maxHeight: 700)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 70)
                        }
                        .frame(maxWidth: proxy.size.width)
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                   value: -$0.frame(in: .named("infoscroll")).origin.y)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            if($0 >= 110 && $0 < 230) {
                                showHeader = true
                                showRealHeader = false
                            } else if($0 >= 230) {
                                showHeader = true
                                showRealHeader = true
                            } else {
                                showHeader = false
                                showRealHeader = false
                            }
                        }
                    }
                }
                .coordinateSpace(name: "infoscroll")
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .frame(.greedy)
        .overlay(alignment: .topTrailing) {
            HStack {
                if globalData.infoData != nil {
                    Text(globalData.infoData!.titles.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex:
                                                globalData.appearance == .system
                                               ? (
                                                colorScheme == .dark
                                                ? Colors.onPrimaryContainer.dark
                                                : Colors.onPrimaryContainer.light
                                               ) : (
                                                globalData.appearance == .dark
                                                ? Colors.onPrimaryContainer.dark
                                                : Colors.onPrimaryContainer.light
                                               )
                                              ))
                        .lineLimit(1)
                        .opacity(showRealHeader ? 1.0 : 0.0)
                        .animation(nil, value: showRealHeader)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        url = ""
                        showInfo = false
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
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
                                              )
                        )
                        .padding(8)
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
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: 110, alignment: .bottom)
            .background {
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
                .opacity(showRealHeader ? 1.0 : 0.0)
                .animation(nil)
            }
        }
        .background {
            if viewModel.htmlString.count > 0 && returnData != nil {
                WebView(htmlString: viewModel.htmlString, javaScript: viewModel.jsString, requestType: "info", enableExternalScripts: returnData!.allowExternalScripts, nextUrl: $nextUrl, mediaConsumeData: .constant(VideoData(sources: [], subtitles: [], skips: [])), mediaConsumeBookData: .constant([]))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .onAppear {
            if globalData.infoData == nil || (globalData.infoData!.mediaList.count > 0 && globalData.infoData!.mediaList[0].count == 0) {
                viewModel.htmlString = ""
                if globalData.newModule != nil {
                    viewModel.htmlString = ""
                    
                    // moduleManager.selectedModuleName
                    
                    // get search js file data
                    if returnData == nil {
                        returnData = moduleManager.getJsForType("info", num: currentJsIndex)
                        viewModel.jsString = returnData!.js
                    }
                    
                    if returnData != nil {
                        Task {
                            
                            if returnData!.request != nil {
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
                                        viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(self.url)\">UNRELATED</div>"
                                    } else {
                                        viewModel.htmlString = html
                                    }
                                    
                                } catch let error {
                                    print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                }
                            } else {
                                let (data, response) = try await URLSession.shared.data(from: URL(string: self.url)!)
                                
                                do {
                                    guard let httpResponse = response as? HTTPURLResponse,
                                          httpResponse.statusCode == 200,
                                          let html = String(data: data, encoding: .utf8) else {
                                        let data = ["data": FloatyData(message: "Failed to load data from \(self.url)", error: true, action: nil)]
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
                                        viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(self.url)\">UNRELATED</div>"
                                    } else {
                                        viewModel.htmlString = html
                                    }
                                } catch let error {
                                    print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .onReceive(globalData.$nextUrl) { next in
            //if navigating { return }
            if next != nil && next!.count > 0 && globalData.infoData != nil && globalData.infoData!.mediaList.count > 0 && globalData.infoData!.mediaList[0].count == 0 {
                viewModel.htmlString = ""
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if globalData.newModule != nil {
                            if currentJsIndex < moduleManager.getJsCount("info") {
                                if currentJsIndex == 0 {
                                    currentJsIndex = 2
                                } else {
                                    currentJsIndex += 1
                                }
                            }
                            
                            // get search js file data
                            returnData = moduleManager.getJsForType("info", num: currentJsIndex)
                            
                            if returnData != nil {
                                viewModel.jsString = returnData!.js
                                
                                Task {
                                    if returnData!.request != nil {
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
                                                viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                            } else {
                                                viewModel.htmlString = html
                                            }
                                        } catch let error {
                                            print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                        }
                                    } else {
                                        let (data, response) = try await URLSession.shared.data(from: URL(string: next!)!)
                                        do {
                                            guard let httpResponse = response as? HTTPURLResponse,
                                                  httpResponse.statusCode == 200,
                                                  let html = String(data: data, encoding: .utf8) else {
                                                
                                                let data = ["data": FloatyData(message: "Failed to load data from \(next!)", error: true, action: nil)]
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
                                                viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                            } else {
                                                viewModel.htmlString = html
                                            }
                                            currentJsIndex += 1
                                        } catch let error {
                                            print(error.localizedDescription)
                                let data = ["data": FloatyData(message: "\(error)", error: true, action: nil)]
                                NotificationCenter.default
                                    .post(name:           NSNotification.Name("floaty"),
                                          object: nil, userInfo: data)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            globalData.nextUrl = ""
            if globalData.infoData != nil {
                globalData.lastVisitedEntry = self.url
                globalData.mediaFailedToLoad = false
            }
        }
        .ignoresSafeArea()
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(url: .constant(""), poster: .constant(""), title: .constant(""), showInfo: .constant(true))
    }
}
