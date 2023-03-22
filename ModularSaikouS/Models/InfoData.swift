//
//  InfoData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import Foundation

struct InfoData: Codable, Hashable {
    let img: String
    let title: String
    let indicatorText: String?
    let currentCount: Int?
    let totalCount: Int?
}
