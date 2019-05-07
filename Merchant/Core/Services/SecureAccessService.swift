//
//  SecureAccessService.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/05/07.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class SecureAccessService: PinDelegate {
    
    var successHandler: (() -> ())?
    var errorHandler: (() -> ())?
    var currentViewController: UIViewController?
    weak var window: UIWindow?
    
    init(_ successHandler:(() -> ())? = nil, errorHandler: (() -> ())? = nil) {
        self.successHandler = successHandler
        self.errorHandler = errorHandler
        
        guard let window = UIApplication.shared.keyWindow
            , let currentViewController = window.rootViewController else {
                // Manage the error here
            return
        }
        
        self.currentViewController = currentViewController
        self.window = window
    }
    
    func onSuccess(_ target: String?) {
        window?.rootViewController = currentViewController
        if let handler = self.successHandler {
            handler()
        }
    }
    
    func onFailure() {
        window?.rootViewController = currentViewController
        if let handler = self.errorHandler {
            handler()
        }
    }
    
    static func transitTo(_ successHandler:@escaping (() -> ()), errorHandler: (() -> ())? = nil) {
        if UserManager.shared.hasPin() {
            let saService = SecureAccessService(successHandler, errorHandler: errorHandler)
            let pinViewController = PinBuilder().provide(.verify, pinDelegate: saService)
            saService.window?.rootViewController = pinViewController
        } else {
            successHandler()
        }
    }
    
    static func setup() {
        if !UserManager.shared.hasPin() {
            let saService = SecureAccessService()
            let pinViewController = PinBuilder().provide(.set, pinDelegate: saService)
            saService.window?.rootViewController = pinViewController
        }
    }
}
