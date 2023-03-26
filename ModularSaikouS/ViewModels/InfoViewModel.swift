//
//  InfoViewModel.swift
//  ModularSaikouS
//
//  Created by Inumaki on 22.03.23.
//

import Foundation

final class InfoViewModel: ObservableObject {
    @Published var htmlString: String = ""
    @Published var loadingMedia: Bool = false
}
