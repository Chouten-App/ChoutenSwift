//
//  Module.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import Foundation

enum subTypes: Codable {
    case VIDEO
    case BOOK
    case TEXT
}

struct Module: Hashable, Equatable, Codable {
    let id: String
    let type: String
    let subtypes: [String]
    var icon: String?
    let name: String
    let version: String
    let formatVersion: Int
    let updateUrl: String
    let general: GeneralMetadata
}

struct GeneralMetadata: Hashable, Equatable, Codable {
    let author: String
    let description: String
    let lang: [String]
    let baseURL: String
    let bgColor: String
    let fgColor: String
}

struct OLDModule: Hashable, Equatable, Codable {
    let id: String
    let type: String
    let subtypes: [String]
    let name: String
    let version: String
    let updateUrl: String
    let metadata: Metadata
    let code: [String: [String: [CodeData]]]
    static func == (lhs: OLDModule, rhs: OLDModule) -> Bool {
        return lhs.type == rhs.type &&
            lhs.subtypes == rhs.subtypes &&
            lhs.name == rhs.name &&
            lhs.version == rhs.version &&
            lhs.updateUrl == rhs.updateUrl &&
            lhs.metadata == rhs.metadata &&
            lhs.code == rhs.code
    }
}

struct CodeData: Hashable, Equatable, Codable {
    let request: Request
    let separator: String?
    let javascript: Javascript
}

struct Javascript: Hashable, Equatable,  Codable {
    let usesApi: Bool?
    let allowExternalScripts: Bool
    let removeScripts: Bool
    let code: String
}

struct Request: Hashable, Equatable, Codable {
    let url: String
    let type: String
    let headers: [Header]
    let body: String?
}

struct Header: Hashable, Equatable, Codable {
    let key: String
    let value: String
}

struct Metadata: Hashable, Equatable, Codable {
    let author: String
    let description: String
    let icon: String
    let lang: [String]
    let baseURL: String
    let bgColor: String
    let fgColor: String
}
