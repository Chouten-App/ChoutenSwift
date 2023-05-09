//
//  SearchBar.swift
//  ModularSaikouS
//
//  Created by Inumaki on 04.05.23.
//

import SwiftUI

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

struct SearchBar: View {
    @Binding var query: String
    @Binding var htmlString: String
    @Binding var jsString: String
    
    @StateObject var Colors: DynamicColors
    @StateObject private var debounceState: DebounceState = DebounceState(initialValue: "")
    
    @State var returnData: ReturnedData? = nil
    
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .padding(14)
            
            ZStack(alignment: .leading) {
                if debounceState.currentValue.isEmpty {
                    if globalData.newModule != nil {
                        Text("Search on \(globalData.newModule!.name)")
                            .foregroundColor(.gray) // Set the placeholder text color here
                    } else {
                        Text("Select a module")
                            .foregroundColor(.gray)
                    }
                }
                
                TextField("", text: $debounceState.currentValue)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onChange(of: isFocused) { isFocused in
                        print(isFocused)
                    }
                    .onChange(of: debounceState.debouncedValue) { newValue in
                        if debounceState.debouncedValue.isEmpty {
                            globalData.searchResults = []
                            return
                        }
                        
                        if globalData.newModule != nil {
                            globalData.searchResults = []
                            globalData.isLoading = true
                            htmlString = ""
                            
                            // moduleManager.selectedModuleName
                            
                            // get search js file data
                            if returnData == nil {
                                returnData = moduleManager.getJsForType("search", num: 0)
                                jsString = returnData!.js
                            }
                            
                            if returnData != nil {
                                Task {
                                    let (data, response) = try await URLSession.shared.data(from: URL(string: returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: "%20")))!)
                                    print(returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: "%20")))
                                    do {
                                        guard let httpResponse = response as? HTTPURLResponse,
                                              httpResponse.statusCode == 200,
                                              let html = String(data: data, encoding: .utf8) else {
                                            print("Invalid response")
                                            let data = ["data": FloatyData(message: "Failed to load data from \(returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue))", error: true, action: nil)]
                                            NotificationCenter.default
                                                .post(name:           NSNotification.Name("floaty"),
                                                      object: nil, userInfo: data)
                                            return
                                        }
                                        if returnData!.usesApi {
                                            print("API!!!")
                                            
                                            
                                            let regexPattern = "&#\\d+;"
                                            let regex = try! NSRegularExpression(pattern: regexPattern)

                                            let range = NSRange(html.startIndex..., in: html)
                                            
                                            let modifiedString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
                                            
                                            let cleaned = modifiedString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'")
                                            //print(cleaned)
                                            htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\">UNRELATED</div>"
                                        } else {
                                            htmlString = html
                                        }
                                        //print(htmlString)
                                        //srprint(jsString)
                                    } catch let error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            /*
                             if globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi != nil && globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].javascript.usesApi! {
                             print(query)
                             globalData.moduleData = nil
                             htmlString = ""
                             print("reload")
                             let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
                             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                             if let error = error {
                             print("Error: \(error.localizedDescription)")
                             globalData.isLoading = false
                             return
                             }
                             print(url)
                             
                             guard let httpResponse = response as? HTTPURLResponse,
                             httpResponse.statusCode == 200,
                             let htmlData = data,
                             let html = String(data: htmlData, encoding: .utf8) else {
                             print("Invalid response")
                             globalData.isLoading = false
                             return
                             }
                             
                             DispatchQueue.main.async {
                             print("setting html string")
                             htmlString = """
                             <div id=\"json-result\" data-json=\"\(html.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "\"", with: "'"))\">UNRELATED</div>
                             """
                             print(htmlString)
                             globalData.reloadPlease = false
                             }
                             }
                             
                             task.resume()
                             
                             } else {
                             print(query)
                             globalData.moduleData = nil
                             htmlString = ""
                             print("reload")
                             let url = URL(string: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].request.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: globalData.module!.code[globalData.module!.subtypes[0]]!["search"]![0].separator ?? "%20")))!
                             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                             if let error = error {
                             print("Error: \(error.localizedDescription)")
                             globalData.isLoading = false
                             return
                             }
                             print(url)
                             
                             guard let httpResponse = response as? HTTPURLResponse,
                             httpResponse.statusCode == 200,
                             let htmlData = data,
                             let html = String(data: htmlData, encoding: .utf8) else {
                             print("Invalid response")
                             globalData.isLoading = false
                             return
                             }
                             
                             DispatchQueue.main.async {
                             print("setting html string")
                             print(html)
                             htmlString = html
                             globalData.reloadPlease = false
                             }
                             }
                             
                             task.resume()
                             
                             }
                             */
                        }
                    }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, -8)
            
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .font(.title3)
                .padding(10)
        }
        .padding(.horizontal, 4)
        .foregroundColor(
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.onSurfaceVariant.dark
                    : Colors.onSurfaceVariant.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.onSurfaceVariant.dark
                    : Colors.onSurfaceVariant.light
                  )
                 )
        )
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
            .cornerRadius(40)
        }
        .textFieldStyle(PlainTextFieldStyle())
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBar(query: .constant(""), htmlString: .constant(""), jsString: .constant(""), Colors: DynamicColors())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hex: DynamicColors().Surface.dark)
        )
        .ignoresSafeArea()
    }
}
