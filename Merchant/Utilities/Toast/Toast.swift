//
//  Toast.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

protocol ToastDelegate: class {
	func toastDidTapOnMessage(_ message: String)
	func toastDidCloseMessage(_ message: String)
}

final class Toast {
	
	// MARK: - Properties
	private var notificationWindow: UIWindow?
	private let toastViewController = ToastViewController()
	weak var delegate: ToastDelegate?
	var preferences = ToastPreferences() {
		didSet {
			toastViewController.preferences = preferences
		}
	}
	
	// MARK: - Initializer
	init() {
		toastViewController.delegate = self
		setupWindow()
	}
	
	// MARK: - Public API
    func displayMessage(_ message: String, forStatus status: ToastStatus) {
		notificationWindow?.isHidden = false
		toastViewController.displayMessage(message, forStatus: status)
	}
	
	// MARK: - Private API
	private func setupWindow() {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.backgroundColor = .clear
		window.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		window.windowLevel = .statusBar
		window.rootViewController = toastViewController
		window.rootViewController!.view.clipsToBounds = true
		window.makeKeyAndVisible()
		window.isHidden = true
		notificationWindow = window
	}
	
}

extension Toast: ToastViewControllerDelegate {
    
    // MARK: - ToastViewControllerDelegate
    func toastViewControllerDidTapOnMessage(_ message: String) {
        delegate?.toastDidTapOnMessage(message)
    }
    
    func toastViewControllerDidCloseMessage(_ message: String) {
        notificationWindow?.isHidden = true
        delegate?.toastDidCloseMessage(message)
    }
    
}
