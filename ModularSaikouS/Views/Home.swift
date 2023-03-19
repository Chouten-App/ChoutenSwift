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

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            if viewModel.globalData.moduleData != nil {
                VStack {
                    KFImage(URL(string: viewModel.globalData.moduleData!.img))
                        .placeholder({
                            RoundedRectangle(cornerRadius: 12)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                    
                    Text(viewModel.globalData.moduleData!.title)
                        .fontWeight(.bold)
                }
            }
            
            //Text(globalData.moduleText ?? moduleText)
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: "myFunction()", globalData: viewModel.globalData)
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onReceive(viewModel.globalData.$selectedModule) { val in
            print("changed")
            viewModel.globalData.moduleData = nil
            viewModel.htmlString = ""
            if viewModel.globalData.url != nil && viewModel.globalData.jsSource != nil {
                let url = URL(string: viewModel.globalData.url!)!
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
                        
                        viewModel.htmlString = viewModel.injectScriptTag(html, scriptTag: viewModel.globalData.jsSource!)
                    }
                }
                
                task.resume()
            }
        }
        .overlay {
            HStack {
                Button {
                    viewModel.showModuleSelector.toggle()
                } label: {
                    Text(viewModel.globalData.selectedModule == nil ? "No Module" : viewModel.globalData.selectedModule!)
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
            BottomSheet(isShowing: $viewModel.showModuleSelector, content: AnyView(ModuleSelector(globalData: viewModel.globalData)))
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
