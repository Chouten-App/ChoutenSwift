//
//  Info.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import SwiftUI
import Kingfisher

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct Info: View {
    let id: String
    @StateObject var globalData: GlobalData
    @StateObject var viewModel: InfoViewModel = InfoViewModel()
    @State var isOn: Bool = false
    @State var showFullDescription: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showHeader: Bool = false
    @State var showRealHeader: Bool = false
    
    var body: some View {
        GeometryReader {proxy in
            if globalData.infoData != nil {
                ScrollView(.vertical, showsIndicators: false) {
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
                                
                                Text("see \(showFullDescription ? "less" : "more")")
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
                .coordinateSpace(name: "infoscroll")
            }
        }
        .navigationBarHidden(true)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.5))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .animation(nil)
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
                    globalData.infoData = nil
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
            VStack {
                if viewModel.htmlString.count > 0 && !globalData.doneInfo {
                    WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code["anime"]!["info"]!.js, requestType: "info", enableExternalScripts: globalData.module!.code["anime"]!["info"]!.allowExternalScripts, globalData: globalData)
                        .hidden()
                        .frame(maxWidth: 0, maxHeight: 0)
                }
                if viewModel.htmlString.count > 0 && globalData.doneInfo {
                    WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code["anime"]!["info"]!.mediaJs!, requestType: "media", enableExternalScripts: globalData.module!.code["anime"]!["info"]!.allowExternalScripts, globalData: globalData)
                        .hidden()
                        .frame(maxWidth: 0, maxHeight: 0)
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(globalData.$doneInfo) { newVal in
            print("Infodata: \(newVal)")
            if newVal {
                print("fetching eps")
                viewModel.htmlString = ""
                Task {
                    if globalData.module!.code["anime"]!["info"]!.mediaUrl != nil {
                        do {
                            let numInId = id.components(separatedBy: "-").last ?? ""
                            
                            let url = URL(string: globalData.module!.code["anime"]!["info"]!.mediaUrl!.replacingOccurrences(of: "ID", with: numInId))!
                            let (data, response) = try await URLSession.shared.data(from: url)
                            
                            guard let httpResponse = response as? HTTPURLResponse,
                                  httpResponse.statusCode == 200,
                                  let html = String(data: data, encoding: .utf8) else {
                                print("Invalid response")
                                return
                            }
                            
                            print("setting html string")
                            
                            viewModel.loadingMedia = true
                            
                            print("setting eps")
                            //print(html)
                            
                            
                            viewModel.htmlString = "<div id=\"json-result\" data-json='\(html.replacingOccurrences(of: "\'", with: "'").replacingOccurrences(of: "'", with: "\'"))'>UNRELATED</div>"
                            
                            print(viewModel.htmlString)
                            
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        .onAppear {
            
            viewModel.htmlString = ""
            print("reload")
            Task {
                do {
                    let url = URL(string: globalData.module!.code["anime"]!["info"]!.url.replacingOccurrences(of: "ID", with: id))!
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
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(id: "",globalData: GlobalData())
    }
}
