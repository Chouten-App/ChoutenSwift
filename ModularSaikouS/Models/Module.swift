//
//  Module.swift
//  ModularSaikouS
//
//  Created by Inumaki on 19.03.23.
//

import Foundation

struct Module: Codable, Hashable {
    var moduleName: String
    var moduleVersion: String
    var js: String
    var callsApi: Bool?
    var website: String
}
