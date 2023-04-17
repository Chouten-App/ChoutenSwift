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
import Combine

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

private class DebounceState<Value>: ObservableObject {
    @Published var currentValue: Value
    @Published var debouncedValue: Value
    
    init(initialValue: Value, delay: Double = 0.4) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}

struct Search: View {
    @StateObject var globalData: GlobalData
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @StateObject private var debounceState: DebounceState = DebounceState(initialValue: "")
    
    @Namespace var animation
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @State var availableModules: [Module] = []
    @State var selectedModuleId: String? = nil
    
    @FocusState private var isFocused: Bool
    
    @State var showPopup = false
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                    
                    ZStack(alignment: .leading) {
                        
                        if debounceState.currentValue.isEmpty {
                            Text("Search for something...")
                                .foregroundColor(.gray) // Set the placeholder text color here
                        }
                        
                        TextField("", text: $debounceState.currentValue)
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
                    if debounceState.currentValue.count > 0 {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("textColor"))
                            .padding(.trailing, 12)
                            .onTapGesture {
                                viewModel.query = ""
                            }
                    }
                }
                .onChange(of: debounceState.debouncedValue, perform: { newValue in
                    if globalData.module != nil {
                        globalData.searchResults = []
                        if globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi != nil && globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi! {
                            print(viewModel.query)
                            globalData.moduleData = nil
                            viewModel.htmlString = ""
                            print("reload")
                            let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
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
                                    viewModel.htmlString = """
                                    <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                                """
                                    print(viewModel.htmlString)
                                    globalData.reloadPlease = false
                                }
                            }
                            
                            task.resume()
                            
                        } else {
                            print(viewModel.query)
                            globalData.moduleData = nil
                            viewModel.htmlString = ""
                            print("reload")
                            let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
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
                })
                .onSubmit {
                    if globalData.module != nil {
                        globalData.searchResults = []
                        if globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi != nil && globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi! {
                            print(viewModel.query)
                            globalData.moduleData = nil
                            viewModel.htmlString = ""
                            print("reload")
                            let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
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
                                    viewModel.htmlString = """
                                <!DOCTYPE html>
                                  <html>
                                    <head>
                                      <title>My Web Page</title>
                                      <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
                                    </head>
                                    <body>
                                                                      <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                                    </body>
                                  </html>
                                """
                                    globalData.reloadPlease = false
                                }
                            }
                            
                            task.resume()
                            
                        } else {
                            print(viewModel.query)
                            globalData.moduleData = nil
                            viewModel.htmlString = ""
                            print("reload")
                            let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: viewModel.query.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
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
            
            
        }
        .background {
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.code, requestType: "search", enableExternalScripts: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.allowExternalScripts, globalData: globalData, nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [])))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .background {
            Color("bg")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay {
            /*if let _ = viewModel.selectedId, viewModel.showInfo {
                Info(url: $viewModel.selectedId, poster: $viewModel.selectedPoster, title: $viewModel.selectedTitle, globalData: globalData, showInfo: $viewModel.showInfo, animation: animation)
                    .transition(.move(edge: .bottom))
            }*/
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Search(globalData: GlobalData())
    }
}
