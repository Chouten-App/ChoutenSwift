//
//  ModuleManager.swift
//  ModularSaikouS
//
//  Created by Inumaki on 06.05.23.
//

import SwiftUI
import JavaScriptCore
import ZIPFoundation

struct ReturnedData: Codable {
    let request: Request?
    let usesApi: Bool
    let allowExternalScripts: Bool
    let removeScripts: Bool
    let imports: [String]
    let js: String
}

class ModuleManager: ObservableObject {
    static let shared = ModuleManager()
    
    init() {
        self.getModules()
    }
    
    @Published var moduleFolderNames: [String] = []
    @Published var moduleIds: [String] = []
    @Published var selectedModuleName: String = ""
    
    func importFromFile(fileUrl: URL) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileManager = FileManager.default
            
            // Create a new directory for the unzipped files
            let unzipDirectoryURL = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(fileUrl.lastPathComponent.components(separatedBy: ".")[0])
            do {
                try fileManager.createDirectory(at: unzipDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                
                // Unzip the file using the ZIPFoundation library
                try FileManager.default.unzipItem(at: fileUrl, to: unzipDirectoryURL)
                
                try FileManager.default.removeItem(at: fileUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getModules() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory.appendingPathComponent("Modules"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                var directoryNames: [String] = []
                for url in directoryContents {
                    var isDirectory: ObjCBool = false
                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                        directoryNames.append(url.lastPathComponent)
                    }
                }
                moduleFolderNames = directoryNames
            } catch {
                print("Error getting directory contents: \(error.localizedDescription)")
            }
        }
    }
    
    func getMetadata(folderUrl: URL) -> Module? {
        print(folderUrl)
        // get metadata.json
        do {
            let metadataData = try Data(contentsOf: folderUrl.appendingPathComponent("metadata.json"))
            //let metadataString = String(data: metadataData, encoding: .utf8)
            var decoded = try JSONDecoder().decode(Module.self, from: metadataData)
            //return metadataString ?? "Unable to decode metadata"
            
            // store icon file path
            decoded.icon = folderUrl.appendingPathComponent("icon.png").absoluteString
            return decoded
        } catch {
            print("Error loading metadata: \(error)")
            //return "Error loading metadata"
            return nil
        }
    }
    
    func getJsCount(_ type: String) -> Int {
        switch type {
        case "search":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let infoDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Search")
                do {
                    let fileUrls = try FileManager.default.contentsOfDirectory(at: infoDirectory, includingPropertiesForKeys: nil)
                    let jsFileUrls = fileUrls.filter { $0.pathExtension == "js" }
                    return jsFileUrls.count
                } catch {
                    print("Error while enumerating files: \(error.localizedDescription)")
                    return 0
                }
            }
            return 0
        case "info":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let infoDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Info")
                do {
                    let fileUrls = try FileManager.default.contentsOfDirectory(at: infoDirectory, includingPropertiesForKeys: nil)
                    let jsFileUrls = fileUrls.filter { $0.pathExtension == "js" }
                    return jsFileUrls.count
                } catch {
                    print("Error while enumerating files: \(error.localizedDescription)")
                    return 0
                }
            }
            return 0
        case "media":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let infoDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Media")
                do {
                    let fileUrls = try FileManager.default.contentsOfDirectory(at: infoDirectory, includingPropertiesForKeys: nil)
                    let jsFileUrls = fileUrls.filter { $0.pathExtension == "js" }
                    return jsFileUrls.count
                } catch {
                    print("Error while enumerating files: \(error.localizedDescription)")
                    return 0
                }
            }
            return 0
        default:
            return 0
        }
    }
    
    func getJsForType(_ type: String, num: Int) -> ReturnedData? {
        switch type {
        case "search":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let searchDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Search")
                    let jsData = try Data(contentsOf: searchDirectory.appendingPathComponent("code.js"))
                    let jsString = String(data: jsData, encoding: .utf8)
                    //print(jsString)
                    
                    // split js into logic and vars
                    let vars = jsString?.components(separatedBy: "function logic() {")[0]
                    var logic = jsString?.components(separatedBy: "function logic() {")[1].trimmingCharacters(in: .whitespaces)
                    if logic != nil {
                        logic = "function logic() {" + logic! + "logic()"
                    }
                    let context = JSContext()

                    context?.evaluateScript(vars)

                    var request: Request?
                    var usesApi: Bool = false
                    var allowExternalScripts: Bool = false
                    var removeScripts: Bool = false
                    var imports: [String] = []
                    
                    if let requestVar = context?.objectForKeyedSubscript("Request") {
                        let url = requestVar.objectForKeyedSubscript("url").toString()
                        let method = requestVar.objectForKeyedSubscript("method").toString()
                        //let headers = requestVar.objectForKeyedSubscript("headers").toArray()
                        let body = requestVar.objectForKeyedSubscript("body").toString()
                        
                        request = Request(url: url ?? "", type: method ?? "GET", headers: [], body: body)
                    }
                    
                    if let usesApiVar = context?.objectForKeyedSubscript("usesApi") {
                        usesApi = usesApiVar.toBool()
                    }
                    
                    if let allowExternalScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        allowExternalScripts = allowExternalScriptsVar.toBool()
                    }
                    
                    if let removeScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        removeScripts = removeScriptsVar.toBool()
                    }
                    
                    if let importsVar = context?.objectForKeyedSubscript("imports") {
                        imports = importsVar.toArray() as? [String] ?? []
                    }
                    
                    if logic != nil {
                        return ReturnedData(request: request, usesApi: usesApi, allowExternalScripts: allowExternalScripts, removeScripts: removeScripts, imports: imports, js: logic!)
                    }
                    
                } catch {
                    print("Error loading metadata: \(error)")
                }
            }
            
            return nil
        case "info":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let searchDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Info")
                    let jsData = try Data(contentsOf: searchDirectory.appendingPathComponent(num == 0 ? "code.js" : "code\(num).js"))
                    let jsString = String(data: jsData, encoding: .utf8)
                    //print(jsString)
                    
                    // split js into logic and vars
                    let vars = jsString?.components(separatedBy: "function logic() {")[0]
                    var logic = jsString?.components(separatedBy: "function logic() {")[1].trimmingCharacters(in: .whitespaces)
                    if logic != nil {
                        logic = "function logic() {" + logic! + "logic()"
                    }
                    let context = JSContext()

                    context?.evaluateScript(vars)

                    var request: Request?
                    var usesApi: Bool = false
                    var allowExternalScripts: Bool = false
                    var removeScripts: Bool = false
                    var imports: [String] = []
                    
                    if let requestVar = context?.objectForKeyedSubscript("Request") {
                        let url = requestVar.objectForKeyedSubscript("url").toString()
                        let method = requestVar.objectForKeyedSubscript("method").toString()
                        //let headers = requestVar.objectForKeyedSubscript("headers").toArray()
                        let body = requestVar.objectForKeyedSubscript("body").toString()
                        
                        if url == "undefined" {
                            request = nil
                        } else {
                            request = Request(url: url ?? "", type: method ?? "GET", headers: [], body: body)
                        }
                    }
                    print(request)
                    
                    if let usesApiVar = context?.objectForKeyedSubscript("usesApi") {
                        usesApi = usesApiVar.toBool()
                    }
                    
                    if let allowExternalScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        allowExternalScripts = allowExternalScriptsVar.toBool()
                    }
                    
                    if let removeScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        removeScripts = removeScriptsVar.toBool()
                    }
                    
                    if let importsVar = context?.objectForKeyedSubscript("imports") {
                        imports = importsVar.toArray() as? [String] ?? []
                    }
                    
                    if logic != nil {
                        return ReturnedData(request: request, usesApi: usesApi, allowExternalScripts: allowExternalScripts, removeScripts: removeScripts, imports: imports, js: logic!)
                    }
                    
                } catch {
                    print("Error loading metadata: \(error)")
                }
            }
            return nil
        case "media":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let searchDirectory = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent(selectedModuleName).appendingPathComponent("Media")
                    let jsData = try Data(contentsOf: searchDirectory.appendingPathComponent(num == 0 ? "code.js" : "code\(num).js"))
                    let jsString = String(data: jsData, encoding: .utf8)
                    //print(jsString)
                    
                    // split js into logic and vars
                    let vars = jsString?.components(separatedBy: "function logic() {")[0]
                    var logic = jsString?.components(separatedBy: "function logic() {")[1].trimmingCharacters(in: .whitespaces)
                    if logic != nil {
                        logic = "function logic() {" + logic! + "logic()"
                    }
                    let context = JSContext()

                    context?.evaluateScript(vars)

                    var request: Request?
                    var usesApi: Bool = false
                    var allowExternalScripts: Bool = false
                    var removeScripts: Bool = false
                    var imports: [String] = []
                    
                    if let requestVar = context?.objectForKeyedSubscript("Request") {
                        let url = requestVar.objectForKeyedSubscript("url").toString()
                        let method = requestVar.objectForKeyedSubscript("method").toString()
                        //let headers = requestVar.objectForKeyedSubscript("headers").toArray()
                        let body = requestVar.objectForKeyedSubscript("body").toString()
                        
                        if url == "undefined" {
                            request = nil
                        } else {
                            request = Request(url: url ?? "", type: method ?? "GET", headers: [], body: body)
                        }
                    }
                    print(request)
                    
                    if let usesApiVar = context?.objectForKeyedSubscript("usesApi") {
                        usesApi = usesApiVar.toBool()
                    }
                    
                    if let allowExternalScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        allowExternalScripts = allowExternalScriptsVar.toBool()
                    }
                    
                    if let removeScriptsVar = context?.objectForKeyedSubscript("usesApi") {
                        removeScripts = removeScriptsVar.toBool()
                    }
                    
                    if let importsVar = context?.objectForKeyedSubscript("imports") {
                        imports = importsVar.toArray() as? [String] ?? []
                    }
                    
                    if logic != nil {
                        return ReturnedData(request: request, usesApi: usesApi, allowExternalScripts: allowExternalScripts, removeScripts: removeScripts, imports: imports, js: logic!)
                    }
                    
                } catch {
                    print("Error loading metadata: \(error)")
                }
            }
            return nil
        default:
            return nil
        }
    }
}
