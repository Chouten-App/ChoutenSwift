//
//  Homeswift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import SwiftUI
import Combine


final class HomeViewModel: ObservableObject {
    
    @Published var showModuleSelector: Bool = false
    @Published var moduleText: String = ""
    @Published var htmlString: String = ""
    
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
