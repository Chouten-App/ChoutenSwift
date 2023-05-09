//
//  NetworkMonitor.swift
//  ModularSaikouS
//
//  Created by Inumaki on 05.05.23.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    @Published var connected: Bool = false
    private var isConnected: Bool = false
    
    init() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                OperationQueue.main.addOperation {
                    self.isConnected = true
                    self.connected = self.isConnected
                }
            } else {
                OperationQueue.main.addOperation {
                    self.isConnected = false
                    self.connected = self.isConnected
                }
                
            }
        }
    }
}
