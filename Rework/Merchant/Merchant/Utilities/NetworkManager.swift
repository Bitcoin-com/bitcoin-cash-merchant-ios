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
    var didStartMonitoringHandler: (() -> Void)?
    var didStopMonitoringHandler: (() -> Void)?
    var networkManagerStatusChangeHandler: (() -> Void)?
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        
        return monitor.currentPath.status == .satisfied
    }
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
     
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    var networkLostMessage: String {
        return Localized.pleaseProvideNetworkConnection
    }
    var timer: Timer?
    
    // MARK: - Initializer
    private init() {
    
    }
    
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
            self.networkManagerStatusChangeHandler?()
            
            if path.status == .satisfied {
                self.resetTimer()
            } else {
                self.configureTimer()
            }
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        
        monitor.cancel()
        self.monitor = nil
        
        isMonitoring = false
        didStopMonitoringHandler?()
    }
    
    // MARK: - Private API
    private func configureTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: Constants.TIMER_TICK_IN_SECONDS, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerTick() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .networkMonitorDidLostConnection, object: nil)
            ToastManager.shared.showMessage(NetworkManager.shared.networkLostMessage, forStatus: .failure)
        }
    }
    
}

private struct Localized {
    static var pleaseProvideNetworkConnection: String { NSLocalizedString("Please provide network connection", comment: "") }
}

extension NSNotification.Name {
    static let networkMonitorDidAcquireConnection = NSNotification.Name("NetworkMonitorDidAcquireConnectionNotification")
    static let networkMonitorDidLostConnection = NSNotification.Name("NetworkMonitorDidLostConnectionNotification")
}

private struct Constants {
    static let TIMER_TICK_IN_SECONDS = 5.0
}
