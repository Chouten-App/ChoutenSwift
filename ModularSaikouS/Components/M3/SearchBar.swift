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
    
    @StateObject var Colors = DynamicColors.shared
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
                        Text("search-placeholder \(globalData.newModule!.name)")
                            .foregroundColor(.gray) // Set the placeholder text color here
                    } else {
                        Text("select-module")
                            .foregroundColor(.gray)
                    }
                }
                
                TextField("", text: $debounceState.currentValue)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onChange(of: debounceState.debouncedValue) { newValue in
                        if debounceState.debouncedValue.isEmpty {
                            globalData.searchResults = []
                            return
                        }
                        
                        if globalData.newModule != nil {
                            print(globalData.newModule!)
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
                                    print(returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "’", with: "").replacingOccurrences(of: ",", with: "")))
                                    let (data, response) = try await URLSession.shared.data(from: URL(string: returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "’", with: "").replacingOccurrences(of: ",", with: "")))!)
                                    do {
                                        guard let httpResponse = response as? HTTPURLResponse,
                                              httpResponse.statusCode == 200,
                                              let html = String(data: data, encoding: .utf8) else {
                                            
                                            let data = ["data": FloatyData(message: "Failed to load data from \(returnData!.request!.url.replacingOccurrences(of: "<query>", with: debounceState.debouncedValue))", error: true, action: nil)]
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
            SearchBar(query: .constant(""), htmlString: .constant(""), jsString: .constant(""))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hex: DynamicColors().Surface.dark)
        )
        .ignoresSafeArea()
    }
}
