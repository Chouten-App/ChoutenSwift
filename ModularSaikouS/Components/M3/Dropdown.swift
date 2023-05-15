//
//  Dropdown.swift
//  ModularSaikouS
//
//  Created by Inumaki on 06.05.23.
//

import SwiftUI

struct Dropdown: View {
    @StateObject var Colors = DynamicColors.shared
    let options: [SeasonData]
    @Binding var htmlString: String
    @Binding var jsString: String
    @Binding var currentJsIndex: Int
    
    @State var selectedOptionData: SeasonData = SeasonData(name: "", url: "")
    
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedOption = 0
    
    @State var open: Bool = false
    
    @State var returnData: ReturnedData? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.headline)
                
                Text("\(options[selectedOption].name)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .scaleEffect(y: open ? -1 : 1)
            }
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
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)
            .background {
                Color(hex:
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
                .cornerRadius(8, corners: open ? [.topLeft, .topRight] : [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .animation(.spring(response: 0.3), value: open)
            }
            .onTapGesture {
                open.toggle()
            }
            .overlay(alignment: .top) {
                ScrollView {
                    VStack {
                        ForEach(0..<options.count) { index in
                            DropdownItem(Colors: Colors, option: options[index], selected: selectedOption == index)
                                .onTapGesture {
                                    selectedOption = index
                                    selectedOptionData = options[index]
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: CGFloat(options.count * 56 + 16) > 400 ? 400 : CGFloat(options.count * 56 + 16))
                .frame(maxHeight: 400)
                .background(
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
                    .cornerRadius(4, corners: [.bottomLeft, .bottomRight])
                    .animation(.spring(response: 0.3), value: open)
                ).shadow(color: Color(hex:
                                        globalData.appearance == .system
                                      ? (
                                        colorScheme == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                      ) : (
                                        globalData.appearance == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                      )
                                     ).opacity(0.08), radius: 2, x: 0, y: 0)
                .shadow(color: Color(hex:
                                        globalData.appearance == .system
                                     ? (
                                        colorScheme == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                     ) : (
                                        globalData.appearance == .dark
                                        ? Colors.Scrim.dark
                                        : Colors.Scrim.light
                                     )
                                    ).opacity(0.16), radius: 24, x: 0, y: 0)
                .scaleEffect(y: open ? 1 : 0, anchor: .top)
                .animation(.easeInOut(duration: 0.1), value: open)
                .padding(.top, 56)
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
        .animation(.spring(response: 0.3), value: open)
        .onChange(of: selectedOptionData) { _ in
            currentJsIndex = 0
            htmlString = ""
            if globalData.newModule != nil {
                globalData.infoData!.mediaList = [[]]
                htmlString = ""
                
                // moduleManager.selectedModuleName
                
                // get search js file data
                if returnData == nil {
                    returnData = moduleManager.getJsForType("info", num: currentJsIndex)
                    jsString = returnData!.js
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
                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(returnData!.request!.url)\">UNRELATED</div>"
                                } else {
                                    htmlString = html
                                }
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        } else {
                            let (data, response) = try await URLSession.shared.data(from: URL(string: selectedOptionData.url)!)
                            
                            do {
                                guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200,
                                      let html = String(data: data, encoding: .utf8) else {
                                    let data = ["data": FloatyData(message: "Failed to load data from \(selectedOptionData.url)", error: true, action: nil)]
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
                                    htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(selectedOptionData.url)\">UNRELATED</div>"
                                    
                                } else {
                                    htmlString = html
                                }
                                print(htmlString)
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                }
            }
        }
        .onReceive(globalData.$nextUrl) { next in
            print(next)
            print(currentJsIndex)
            if next != nil && next!.count > 0 && open {
                htmlString = ""
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
                            
                            if returnData == nil {
                                returnData = moduleManager.getJsForType("info", num: moduleManager.getJsCount("info"))
                            }
                            
                            
                            if returnData != nil {
                                jsString = returnData!.js
                                
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
                                                htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(returnData!.request!.url)\">UNRELATED</div>"
                                            } else {
                                                htmlString = html
                                            }
                                        } catch let error {
                                            print(error.localizedDescription)
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
                                                htmlString = "<div id=\"json-result\" data-json=\"\(cleaned)\" data-url=\"\(next!)\">UNRELATED</div>"
                                            } else {
                                                htmlString = html
                                            }
                                            currentJsIndex += 1
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DropdownItem: View {
    @StateObject var Colors = DynamicColors.shared
    let option: SeasonData
    var selected = false
    
    @StateObject var globalData = GlobalData.shared
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text(option.name)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .background(Color(hex:
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
                             ).opacity(selected ? 0.12 : 0.0))
    }
}

struct Dropdown_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Dropdown(options: [SeasonData(name: "Classic Series", url: ""),SeasonData(name: "Z Series", url: ""),SeasonData(name: "GT Series", url: ""),SeasonData(name: "Z Kai Series", url: ""),SeasonData(name: "Z Kai Series: Final", url: ""),SeasonData(name: "Super Series", url: ""),SeasonData(name: "Super Heroes Series", url: "")], htmlString: .constant(""), jsString: .constant(""), currentJsIndex: .constant(0))
                .padding(.top, 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(hex: DynamicColors().Surface.dark))
    }
}
