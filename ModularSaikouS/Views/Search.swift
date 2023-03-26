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

struct APIResponse: Codable {
    let title: Title
    let image: String
}

struct Title: Codable {
    let romaji: String
}

struct Search: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @StateObject var globalData: GlobalData = GlobalData()
    
    func fetchFromApi() {
        let url = URL(string: globalData.module!.code["anime"]!["search"]!.url)!
        
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
                globalData.moduleData = SearchData(id: "",img: img, title: title, indicatorText: nil, currentCount: nil, totalCount: nil)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    var body: some View {
        VStack {
            if globalData.moduleData != nil {
                VStack {
                    KFImage(URL(string: globalData.moduleData!.img))
                        .placeholder({
                            RoundedRectangle(cornerRadius: 12)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                    
                    Text(globalData.moduleData!.title)
                        .fontWeight(.bold)
                }
            }
            
            ZStack(alignment: .leading) {
                if viewModel.query.isEmpty {
                    Text("Search for something...")
                        .foregroundColor(.gray) // Set the placeholder text color here
                }
                TextField("", text: $viewModel.query)
            }
            .foregroundColor(Color("textColor"))
            .frame(maxHeight: 40)
            .padding(.leading, 20)
            .textFieldStyle(PlainTextFieldStyle())
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("accentColor1"))
            }
            .onSubmit {
                if globalData.module != nil {
                    globalData.searchResults = []
                    if globalData.module!.code["anime"]!["search"]!.usesApi != nil && globalData.module!.code["anime"]!["search"]!.usesApi! {
                        fetchFromApi()
                    } else {
                        print(viewModel.query)
                        globalData.moduleData = nil
                        viewModel.htmlString = ""
                        print("reload")
                        let url = URL(string: globalData.module!.code["anime"]!["search"]!.url.replacingOccurrences(of: "QUERY", with: viewModel.query.replacingOccurrences(of: " ", with: "%20")))!
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
                                
                                viewModel.htmlString = html
                                globalData.reloadPlease = false
                            }
                        }
                        
                        task.resume()
                        
                    }
                }
            }
            
            .padding(.horizontal, 20)
            .padding(.top, 80)
            .padding(.bottom, 20)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100), alignment: .top)
                ], spacing: 20) {
                    ForEach(globalData.searchResults, id: \.self) {result in
                        NavigationLink(destination: Info(id: result.id,globalData: globalData)
                            .navigationBarHidden(true)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5))) {
                                SearchCard(image: result.img, title: result.title, hasIndicator: result.indicatorText != nil, indicatorText: result.indicatorText, currentCount: result.currentCount, totalCount: result.totalCount, type: .GRID, cover: nil)
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code["anime"]!["search"]!.js, requestType: "search", enableExternalScripts: globalData.module!.code["anime"]!["search"]!.allowExternalScripts, globalData: globalData)
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
        .ignoresSafeArea()
        .onAppear{
            print("Application directory: \(NSHomeDirectory())")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
