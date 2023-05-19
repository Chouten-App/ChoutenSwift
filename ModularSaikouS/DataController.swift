//
//  DataController.swift
//  Inus Stream
//
//  Created by Inumaki on 28.09.22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "UserData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                //TODO: add UserInterface to show user that something went wrong
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
