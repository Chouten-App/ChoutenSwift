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
    @StateObject var globalData: GlobalData
    @Binding var showInfo: Bool
    var animation: Namespace.ID?
    @StateObject var viewModel: InfoViewModel = InfoViewModel()
    @State var isOn: Bool = false
    @State var showFullDescription: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.presenter) var presenter
    
    @State var showHeader: Bool = false
    @State var showRealHeader: Bool = false
    @State var nextUrl: String = ""
    @State var currentJsIndex = 0
    
    var body: some View {
        GeometryReader {proxy in
            ScrollView(.vertical, showsIndicators: false) {
                if globalData.infoData != nil {
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom, spacing: 0) {
                            HStack {
                                Text(globalData.infoData!.titles.primary)
                                    .foregroundColor(Color("textColor2"))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(12)
                            .frame(minWidth: proxy.size.width, maxWidth: proxy.size.width, maxHeight: 110, alignment: .bottomLeading)
                            .background {
                                Color("bg2")
                            }
                            .padding(.bottom, -60)
                            
                            
                            ZStack(alignment: .bottomLeading) {
                                GeometryReader {reader in
                                    FillAspectImage(
                                        url: URL(string: globalData.infoData!.banner ?? globalData.infoData!.poster),
                                        doesAnimateHorizontal: proxy.size.width < 900
                                    )
                                    .blur(radius: globalData.infoData!.banner != nil ? 0.0 : 6.0)
                                    .overlay {
                                        LinearGradient(stops: [
                                            Gradient.Stop(color: Color("bg").opacity(0.9), location: 0.0),
                                            Gradient.Stop(color: Color("bg").opacity(0.4), location: 1.0),
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
                                    KFImage(URL(string: globalData.infoData!.poster))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 120, maxHeight: 180)
                                        .cornerRadius(12)
                                        .if(animation != nil) { view in
                                            // We only apply this background color if shouldApplyBackground is true
                                            view.matchedGeometryEffect(id: title, in: animation!)
                                        }
                                    
                                    VStack(alignment: .leading) {
                                        Text(globalData.infoData!.titles.secondary ?? "")
                                            .font(.caption)
                                            .fontWeight(.heavy)
                                            .foregroundColor(Color("textColor2").opacity(0.7))
                                        Text(globalData.infoData!.titles.primary)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("textColor2"))
                                            .lineLimit(3)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(globalData.infoData!.status ?? "")
                                                .foregroundColor(Color("accentColor1"))
                                                .fontWeight(.bold)
                                            
                                            Text("\(globalData.infoData!.totalMediaCount ?? 0) \(globalData.infoData!.mediaType)")
                                                .foregroundColor(Color("textColor2"))
                                                .font(.subheadline)
                                                .fontWeight(.bold)
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
                                Text(globalData.infoData!.description)
                                    .foregroundColor(Color("textColor2").opacity(0.7))
                                    .font(.subheadline)
                                    .lineLimit(showFullDescription ? 100 : 9)
                                    .animation(.spring(response: 0.3), value: showFullDescription)
                                
                                Text("See \(showFullDescription ? "less" : "more")")
                                    .foregroundColor(Color("accentColor1"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.top, 4)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .animation(.spring(response: 0.3), value: showFullDescription)
                                    .onTapGesture {
                                        showFullDescription.toggle()
                                    }
                            }
                            .animation(.spring(response: 0.3), value: showFullDescription)
                            
                            
                            Toggle(isOn ? "Dubbed" : "Subbed", isOn: $isOn)
                                .toggleStyle(MaterialToggleStyle())
                            
                            HStack(alignment: .bottom) {
                                Text(globalData.infoData!.mediaType)
                                    .foregroundColor(Color("accentColor1"))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 6)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Source")
                                        .font(.subheadline)
                                        .foregroundColor(Color("textColor2"))
                                        .padding(.trailing, 4)
                                        .padding(.bottom, -4)
                                    
                                    HStack {
                                        Text("Zoro.to")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color("textColor"))
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(Color("textColor"))
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .background {
                                        Capsule()
                                            .fill(Color("accentColor1"))
                                    }
                                }
                            }
                            
                            if globalData.infoData!.seasons.count > 0 {
                                HStack {
                                    Image(systemName: "folder.fill")
                                        .font(.subheadline)
                                    
                                    Text(globalData.infoData!.seasons[0])
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 12)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                }
                                .foregroundColor(Color("textColor"))
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, maxHeight: 42, alignment: .leading)
                                .background {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color("accentColor1"))
                                }
                                .padding(.vertical, 8)
                            }
                            
                            ScrollView {
                                VStack(spacing: 20) {
                                    ForEach(0..<globalData.infoData!.mediaList[0].count, id: \.self) {index in
                                        NavigationLink(destination: WatchPage(url: globalData.infoData!.mediaList[0][index].url, globalData: globalData)) {
                                            VStack(spacing: 0) {
                                                HStack(spacing: 8) {
                                                    KFImage(URL(string: globalData.infoData!.mediaList[0][index].image ?? globalData.infoData!.poster))
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: 150, maxHeight: 90)
                                                        .cornerRadius(12)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Spacer()
                                                        
                                                        HStack {
                                                            Text(globalData.infoData!.mediaList[0][index].title ?? "Episode \(globalData.infoData!.mediaList[0][index].number)")
                                                                .foregroundColor(Color("textColor2"))
                                                                .font(.subheadline)
                                                                .fontWeight(.semibold)
                                                                .lineLimit(2)
                                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                            
                                                            /*
                                                             Image(systemName: "arrow.down.to.line.compact")
                                                             .font(.callout)
                                                             .foregroundColor(Color("textColor"))
                                                             .padding(8)
                                                             .background {
                                                             Circle()
                                                             .fill(Color("accentColor1"))
                                                             }
                                                             */
                                                        }
                                                        Spacer()
                                                        
                                                        HStack {
                                                            Text("Episode \(globalData.infoData!.mediaList[0][index].number)")
                                                                .foregroundColor(Color("textColor2").opacity(0.7))
                                                                .font(.caption)
                                                                .fontWeight(.semibold)
                                                            
                                                            Spacer()
                                                            
                                                            Text("24 mins")
                                                                .foregroundColor(Color("textColor2").opacity(0.7))
                                                                .font(.caption)
                                                                .fontWeight(.semibold)
                                                        }
                                                        .padding(.bottom, 6)
                                                    }
                                                    .padding(.trailing, 8)
                                                    .frame(maxWidth: .infinity, maxHeight: 90, alignment: .leading)
                                                }
                                                if globalData.infoData!.mediaList[0][index].description != nil {
                                                    Text(globalData.infoData!.mediaList[0][index].description!)
                                                        .font(.caption)
                                                        .foregroundColor(Color("textColor2").opacity(0.7))
                                                        .lineLimit(4)
                                                        .padding(12)
                                                }
                                            }
                                            .background {
                                                Color("bg2")
                                            }
                                            .cornerRadius(12)
                                            
                                        }
                                    }
                                }
                                .padding(.bottom, 60)
                            }
                            .padding(.top, 12)
                            .frame(maxHeight: 700)
                        }
                        .animation(.spring(response: 0.3), value: showFullDescription)
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
                                Color("bg2")
                            }
                            .padding(.bottom, -60)
                            
                            
                            ZStack(alignment: .bottomLeading) {
                                GeometryReader {reader in
                                    Rectangle()
                                        .overlay {
                                            LinearGradient(stops: [
                                                Gradient.Stop(color: Color("bg").opacity(0.9), location: 0.0),
                                                Gradient.Stop(color: Color("bg").opacity(0.4), location: 1.0),
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
                                .toggleStyle(MaterialToggleStyle())
                            
                            HStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(maxWidth: proxy.size.width * 0.25, maxHeight: 20)
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                                    .padding(.bottom, 6)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Source")
                                        .font(.subheadline)
                                        .foregroundColor(Color("textColor2"))
                                        .padding(.trailing, 4)
                                        .padding(.bottom, -4)
                                    
                                    HStack {
                                        Text("Zoro.to")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color("textColor"))
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(Color("textColor"))
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .background {
                                        Capsule()
                                            .fill(Color("accentColor1"))
                                    }
                                }
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
                                            Color("bg2")
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
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(alignment: .topTrailing) {
            HStack {
                if globalData.infoData != nil {
                    Text(globalData.infoData!.titles.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("textColor2"))
                        .lineLimit(1)
                        .opacity(showRealHeader ? 1.0 : 0.0)
                        .animation(nil)
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
                        .foregroundColor(Color("textColor"))
                        .padding(8)
                        .background {
                            Circle()
                                .fill(Color("accentColor1"))
                        }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: 110, alignment: .bottom)
            .background {
                Color("bg2")
                    .opacity(showRealHeader ? 1.0 : 0.0)
                    .animation(nil)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("bg")
        }
        .background {
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code["anime"]!["info"]![currentJsIndex].javascript.code, requestType: "info", enableExternalScripts: globalData.module!.code["anime"]!["info"]![currentJsIndex].javascript.allowExternalScripts, globalData: globalData, nextUrl: $nextUrl, mediaConsumeData: .constant(VideoData(sources: [], subtitles: [])))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.htmlString = ""
            print("reload")
            Task {
                if self.url != nil && self.url.count > 0{
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
                        
                        print("setting html string")
                        
                        viewModel.htmlString = html
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        .onReceive(globalData.$nextUrl) { next in
            if next != nil && next!.count > 0 {
                viewModel.htmlString = ""
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Task {
                            do {
                                if currentJsIndex < globalData.module!.code["anime"]!["info"]!.count - 1 {
                                    currentJsIndex += 1
                                }
                                let (data, response) = try await URLSession.shared.data(from: URL(string: next!)!)
                                
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    print("Invalid response")
                                    return
                                }
                                if globalData.module!.code["anime"]!["info"]![currentJsIndex].javascript.usesApi != nil && globalData.module!.code["anime"]!["info"]![currentJsIndex].javascript.usesApi! == true {
                                    print("API!!!")
                                    let cleaned = html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "&#39;", with: "").replacingOccurrences(of: "\"", with: "'")
                                    //print(cleaned)
                                    viewModel.htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                    print(viewModel.htmlString)
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
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(url: .constant(""), poster: .constant(""), title: .constant(""),globalData: GlobalData(), showInfo: .constant(true))
    }
}
