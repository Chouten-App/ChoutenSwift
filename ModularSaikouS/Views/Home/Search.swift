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
import ActivityIndicatorView

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
    @StateObject var Colors = DynamicColors.shared
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @StateObject private var debounceState: DebounceState = DebounceState(initialValue: "")
    @StateObject var globalData = GlobalData.shared
    
    @Namespace var animation
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @State var availableModules: [OLDModule] = []
    @State var selectedModuleId: String? = nil
    
    @FocusState private var isFocused: Bool
    
    @State var showPopup = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if globalData.newModule != nil {
                if !globalData.isLoading {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100), alignment: .top)
                        ], spacing: 20) {
                            ForEach(globalData.searchResults, id: \.self) {result in
                                if !(viewModel.showInfo && viewModel.selectedId == result.url) {
                                    NavigationLink(destination: Info(url: .constant(result.url), poster: .constant(result.img), title: .constant(result.title), showInfo: $viewModel.showInfo, Colors: Colors, animation: animation)) {
                                        SearchCard(image: result.img, title: result.title, hasIndicator: result.indicatorText != nil, indicatorText: result.indicatorText, currentCount: result.currentCount, totalCount: result.totalCount, type: .GRID, cover: nil, Colors: Colors, animation: animation)
                                    }.simultaneousGesture(TapGesture().onEnded{
                                        if globalData.lastVisitedEntry != result.url {
                                            globalData.infoData = nil
                                        }
                                    })
                                }
                            }
                        }
                        .padding(.top, 140)
                        .padding(.bottom, 120)
                        .padding(.horizontal, 20)
                    }
                } else {
                    VStack{
                        ActivityIndicatorView(isVisible: $globalData.isLoading, type: .growingArc(Color(hex:
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
                                                                                                       ), lineWidth: 4)) .frame(width: 50.0, height: 50.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            } else {
                VStack {
                    Text("nothing-text")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(
                    Color(hex:
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
                         )
                )
            }
        }
        .background {
            if viewModel.htmlString.count > 0 {
                WebView(htmlString: viewModel.htmlString, javaScript: viewModel.jsString, requestType: "search", enableExternalScripts: viewModel.allowExternalStrings, nextUrl: .constant(""), mediaConsumeData: .constant(VideoData(sources: [], subtitles: [], skips: [])), mediaConsumeBookData: .constant([]))
                    .hidden()
                    .frame(maxWidth: 0, maxHeight: 0)
            }
        }
        .background {
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.Surface.dark
                    : Colors.Surface.light
                  )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay {
            /*if let _ = viewModel.selectedId, viewModel.showInfo {
             Info(url: $viewModel.selectedId, poster: $viewModel.selectedPoster, title: $viewModel.selectedTitle, showInfo: $viewModel.showInfo, animation: animation)
             .transition(.move(edge: .bottom))
             }*/
        }
        .overlay(alignment: .top) {
            SearchBar(query: $viewModel.query, htmlString: $viewModel.htmlString, jsString: $viewModel.jsString, Colors: Colors)
                .padding(.horizontal, 20)
                .padding(.top, 80)
                .padding(.bottom, 20)
                .animation(.easeInOut, value: isFocused)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
