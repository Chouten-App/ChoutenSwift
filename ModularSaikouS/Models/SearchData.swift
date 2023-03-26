//
//  InfoData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import Foundation

struct SearchData: Codable, Hashable {
    let id: String
    let img: String
    let title: String
    let indicatorText: String?
    let currentCount: Int?
    let totalCount: Int?
}
