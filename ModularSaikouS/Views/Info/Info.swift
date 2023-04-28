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
    @StateObject var Colors: DynamicColors
    var animation: Namespace.ID?
    @StateObject var viewModel: InfoViewModel = InfoViewModel()
    @State var isOn: Bool = false
    @State var showFullDescription: Bool = false
    @StateObject var globalData = GlobalData.shared
    
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
                        InfoDisplay(Colors: Colors, proxy: proxy, showHeader: $showHeader, title: title, showFullDescription: $showFullDescription, isOn: $isOn, navigating: $navigating)
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
                                //print("offset >> \($0)")
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
                            //print("offset >> \($0)")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            HStack {
                if globalData.infoData != nil {
                    Text(globalData.infoData!.titles.primary)
                        .font(.title2)
                        .fontWeight(.bold)
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
            if !navigating && viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code[globalData.module!.subtypes[0]]!["info"]![currentJsIndex].javascript.code, requestType: "info", enableExternalScripts: globalData.module!.code[globalData.module!.subtypes[0]]!["info"]![currentJsIndex].javascript.allowExternalScripts, nextUrl: $nextUrl, mediaConsumeData: .constant(VideoData(sources: [], subtitles: [], skips: [])), mediaConsumeBookData: .constant([]))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .onAppear {
            viewModel.htmlString = ""
            Task {
                if self.url.count > 0 {
                    do {
                        print(self.url)
                        let url = URL(string: self.url)!
                        let (data, response) = try await URLSession.shared.data(from: url)
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode == 200,
                              let html = String(data: data, encoding: .utf8) else {
                            print("Invalid response")
                            return
                        }
                        if globalData.module!.code[globalData.module!.subtypes[0]]!["info"]![currentJsIndex].javascript.usesApi == true {
                            viewModel.htmlString = """
                            <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                        """
                        } else {
                            viewModel.htmlString = html
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        .onReceive(globalData.$nextUrl) { next in
            //if navigating { return }
            if next != nil && next!.count > 0 {
                viewModel.htmlString = ""
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Task {
                            do {
                                if currentJsIndex < globalData.module!.code[globalData.module!.subtypes[0]]!["info"]!.count - 1 {
                                    currentJsIndex += 1
                                }
                                let (data, response) = try await URLSession.shared.data(from: URL(string: next!)!)
                                
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    print("Invalid response")
                                    return
                                }
                                if globalData.module!.code[globalData.module!.subtypes[0]]!["info"]![currentJsIndex].javascript.usesApi != nil && globalData.module!.code[globalData.module!.subtypes[0]]!["info"]![currentJsIndex].javascript.usesApi! == true {
                                    print("API!!!")
                                    let cleaned = html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "&#39;", with: "").replacingOccurrences(of: "\"", with: "'")
                                    //print(cleaned)
                                    viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                } else {
                                    viewModel.htmlString = html
                                }
                            } catch let error {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            globalData.nextUrl = ""
        }
        .ignoresSafeArea()
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(url: .constant(""), poster: .constant(""), title: .constant(""), showInfo: .constant(true), Colors: DynamicColors())
    }
}
