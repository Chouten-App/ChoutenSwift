//
//  Homeswift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import Combine


final class SearchViewModel: ObservableObject {
    
    @Published var showModuleSelector: Bool = false
    @Published var moduleText: String = ""
    @Published var htmlString: String = ""
    @Published var query: String = ""
    
    @Published var showInfo: Bool = false
    @Published var selectedId: String = ""
    @Published var selectedPoster: String = ""
    @Published var selectedTitle: String = ""
    
    func injectScriptTag(_ htmlString: String, scriptTag: String) -> String {
        guard let range = htmlString.range(of: "</head>") else {
            // If the "</head>" tag is not found, return the original HTML string
            return htmlString
        }
        let headEndIndex = range.upperBound
        var newHTMLString = htmlString
        newHTMLString.insert(contentsOf: scriptTag, at: headEndIndex)
        return newHTMLString
    }
    
}
