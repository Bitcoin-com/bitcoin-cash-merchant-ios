//
//  NetworkManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import Network

final class NetworkManager {

    // MARK: - Properties
    static let shared = NetworkManager()
    private var monitor: NWPathMonitor?
    var isMonitoring = false
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        
        return monitor.currentPath.status == .satisfied
    }
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Deinitializer
    deinit {
        stopMonitoring()
    }
    
    // MARK: - Public API
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        
        let queue = DispatchQueue(label: "NetworkManager_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .networkMonitorDidAcquireConnection, object: nil)
                }
            } else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .networkMonitorDidLostConnection, object: nil)
                }
            }
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        
        monitor.cancel()
        self.monitor = nil
        
        isMonitoring = false
    }
    
}

extension NSNotification.Name {
    static let networkMonitorDidAcquireConnection = NSNotification.Name("NetworkMonitorDidAcquireConnectionNotification")
    static let networkMonitorDidLostConnection = NSNotification.Name("NetworkMonitorDidLostConnectionNotification")
}
