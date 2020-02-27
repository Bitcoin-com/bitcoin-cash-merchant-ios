//
//  ToastManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

enum ToastStatus {
    case failure
    case success
}

final class ToastManager {
    
    // MARK: - Properties
    static let shared = ToastManager()
    private let toast = Toast()
    private let preferences = ToastPreferences()
    
    // MARK: - Initializer
    init() {
        toast.delegate = self
        toast.preferences = preferences
    }
    
    // MARK: - Public API
    func showMessage(_ message: String, forStatus status: ToastStatus) {
        toast.displayMessage(message, forStatus: status)
    }
    
}

extension ToastManager: ToastDelegate {
    
    // MARK: - ToastDelegate
    func toastDidTapOnMessage(_ message: String) {
        
    }
    
    func toastDidCloseMessage(_ message: String) {
        
    }
    
}
