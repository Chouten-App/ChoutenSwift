//
//  HomeData.swift
//  ModularSaikouS
//
//  Created by Inumaki on 13.05.23.
//

import Foundation

struct HomeComponent: Codable {
    let type: String
    let title: String
    let data: [HomeData]
}

struct HomeData: Codable {
    let url: String
    let titles: Titles
    let image: String
    let subtitle: String
    let subtitleValue: [String]
    let buttonText: String
    let iconText: String?
    let showIcon: Bool
    let indicator: String?
    let current: Int?
    let total: Int?
}
