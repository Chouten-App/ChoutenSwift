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

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @StateObject var globalData: GlobalData = GlobalData()
    
    func fetchFromApi() {
        let url = URL(string: globalData.module!.website)!
        
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
                globalData.moduleData = InfoData(img: img, title: title)
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
            
            //Text(globalData.moduleText ?? moduleText)
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: "myFunction()", globalData: globalData)
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .onReceive(globalData.$reloadPlease) { newVal in
            if globalData.module != nil {
                if globalData.module!.callsApi != nil && globalData.module!.callsApi! {
                    
                    fetchFromApi()
                } else {
                    if globalData.reloadPlease {
                        globalData.moduleData = nil
                        viewModel.htmlString = ""
                        print("reload")
                        let url = URL(string: globalData.module!.website)!
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let httpResponse = response as? HTTPURLResponse,
                                  httpResponse.statusCode == 200,
                                  let htmlData = data,
                                  let html = String(data: htmlData, encoding: .utf8) else {
                                print("Invalid response")
                                return
                            }
                            
                            DispatchQueue.main.async {
                                print("setting html string")
                                
                                viewModel.htmlString = viewModel.injectScriptTag(html, scriptTag: globalData.module!.js)
                                print(viewModel.htmlString)
                                globalData.reloadPlease = false
                            }
                        }
                        
                        task.resume()
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay {
            HStack {
                Button {
                    viewModel.showModuleSelector.toggle()
                } label: {
                    Text(globalData.selectedModule == nil ? "No Module" : globalData.selectedModule!)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#FF007F"))
                        }
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 80)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .overlay {
            BottomSheet(isShowing: $viewModel.showModuleSelector, content: AnyView(ModuleSelector(globalData: globalData)))
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
