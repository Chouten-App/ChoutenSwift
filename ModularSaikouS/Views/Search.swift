//
//  ContentView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI
import WebKit
import Kingfisher
import Shimmer
import SwiftUIX

struct APIResponse: Codable {
    let title: Title
    let image: String
}

struct Title: Codable {
    let romaji: String
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct Search: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @StateObject var globalData: GlobalData = GlobalData()
    
    @Namespace var animation
    
    func fetchFromApi() {
        let url = URL(string: globalData.module!.code["anime"]!["search"]![0].request.url)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                print(data)
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                
                let title = apiResponse.title.romaji
                let img = apiResponse.image
                globalData.moduleData = SearchData(url: "",img: img, title: title, indicatorText: nil, currentCount: nil, totalCount: nil)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.subheadline)
                        
                        ZStack(alignment: .leading) {
                            
                            if viewModel.query.isEmpty {
                                Text("Search for something...")
                                    .foregroundColor(.gray) // Set the placeholder text color here
                            }
                            TextField("", text: $viewModel.query)
                                .focused($isFocused)
                                .onChange(of: isFocused) { isFocused in
                                    print(isFocused)
                                }
                        }
                    }
                    .foregroundColor(Color("textColor"))
                    .frame(maxHeight: 32)
                    .padding(.leading, 12)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("accentColor1"))
                    }
                    .overlay(alignment: .trailing) {
                        if viewModel.query.count > 0 {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color("textColor"))
                                .padding(.trailing, 12)
                                .onTapGesture {
                                    viewModel.query = ""
                                }
                        }
                    }
                    .onSubmit {
                        if globalData.module != nil {
                            globalData.searchResults = []
                            if globalData.module!.code["anime"]!["search"]![0].javascript.usesApi != nil && globalData.module!.code["anime"]!["search"]![0].javascript.usesApi! {
                                fetchFromApi()
                            } else {
                                print(viewModel.query)
                                globalData.moduleData = nil
                                viewModel.htmlString = ""
                                print("reload")
                                let url = URL(string: globalData.module!.code["anime"]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: viewModel.query.replacingOccurrences(of: " ", with: globalData.module!.code["anime"]!["search"]![0].separator ?? "%20")))!
                                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        return
                                    }
                                    print(url)
                                    
                                    guard let httpResponse = response as? HTTPURLResponse,
                                          httpResponse.statusCode == 200,
                                          let htmlData = data,
                                          let html = String(data: htmlData, encoding: .utf8) else {
                                        print("Invalid response")
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        print("setting html string")
                                        print(html)
                                        viewModel.htmlString = html
                                        globalData.reloadPlease = false
                                    }
                                }
                                
                                task.resume()
                                
                            }
                        }
                    }
                    
                    if isFocused {
                        Text("Cancel")
                            .padding(.leading, 12)
                            .foregroundColor(Color("textColor2"))
                            .onTapGesture {
                                isFocused = false
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)
                .padding(.bottom, 20)
                .animation(.easeInOut, value: isFocused)
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100), alignment: .top)
                    ], spacing: 20) {
                        ForEach(globalData.searchResults, id: \.self) {result in
                            if !(viewModel.showInfo && viewModel.selectedId == result.url) {
                                NavigationLink(destination: Info(url: .constant(result.url), poster: .constant(result.img), title: .constant(result.title), globalData: globalData, showInfo: $viewModel.showInfo, animation: animation)) {
                                        SearchCard(image: result.img, title: result.title, hasIndicator: result.indicatorText != nil, indicatorText: result.indicatorText, currentCount: result.currentCount, totalCount: result.totalCount, type: .GRID, cover: nil, animation: animation)
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                if viewModel.htmlString.count > 0 {
                    WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code["anime"]!["search"]![0].javascript.code, requestType: "search", enableExternalScripts: globalData.module!.code["anime"]!["search"]![0].javascript.allowExternalScripts, globalData: globalData, nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [])))
                        .hidden()
                        .frame(maxWidth: 0, maxHeight: 0)
                }
            }
            .background {
                Color("bg")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.showModuleSelector.toggle()
                } label: {
                    Text(globalData.module == nil ? "No Module" : globalData.module!.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color("textColor"))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("accentColor1"))
                        }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 20)
                .padding(.bottom, 80)
            }
            .overlay {
                BottomSheet(isShowing: $viewModel.showModuleSelector, content: AnyView(ModuleSelector(globalData: globalData)))
            }
            .overlay {
                /*if let _ = viewModel.selectedId, viewModel.showInfo {
                    Info(url: $viewModel.selectedId, poster: $viewModel.selectedPoster, title: $viewModel.selectedTitle, globalData: globalData, showInfo: $viewModel.showInfo, animation: animation)
                        .transition(.move(edge: .bottom))
                }*/
            }
            .ignoresSafeArea()
            .onAppear{
                print("Application directory: \(NSHomeDirectory())")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
