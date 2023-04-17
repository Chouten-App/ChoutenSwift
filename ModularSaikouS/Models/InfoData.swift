//
//  InfoData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 24.03.23.
//

import Foundation

struct InfoData: Codable {
    let id: String
    let titles: Titles
    let altTitles: [String]
    let description: String
    let poster: String
    let banner: String?
    let status: String?
    let totalMediaCount: Int?
    let mediaType: String
    let seasons: [String]
    var mediaList: [[MediaItem]]
}

struct MediaItem: Codable {
    let url: String
    let number: Double
    let title: String?
    let description: String?
    let image: String?
}

struct Titles: Codable {
    let primary: String
    let secondary: String?
}
