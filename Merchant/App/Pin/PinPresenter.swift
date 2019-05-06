//
//  PinPresenter.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

protocol PinDelegate {
    func onSuccess(_ target: String?)
    func onFailure()
}

class PinPresenter {
    var router: PinRouter?
    weak var viewDelegate: PinController?
    var pinDelegate: PinDelegate?

    var target: String?
    var currentPin: String
    var newPin: String?
    var pinMode: PinMode
    
    init(_ pinMode: PinMode, target: String?) {
        currentPin = UserManager.shared.pin;
        self.pinMode = pinMode
        self.target = target
    }
    
    func viewDidLoad() {
        switch pinMode {
        case .verify:
            viewDelegate?.setupPin("Enter pin code")
        case .change:
            viewDelegate?.setupPin("Enter current pin code")
        case .set:
            viewDelegate?.setupPin("Create pin code")
        }
    }
}

extension PinPresenter {
    
    func didSetPin(_ pin: String) {
        if pin.count < 5 {
            viewDelegate?.showPins(pin.count)
            
            if pin.count == 4 {
                switch pinMode {
                case .verify:
                    router?.transitBack()
                    if pin == currentPin {
                        pinDelegate?.onSuccess(target)
                    } else {
                        pinDelegate?.onFailure()
                    }
                case .set:
                    if let newPin = self.newPin {
                        if pin == newPin {
                            UserManager.shared.setPin(newPin)
                            router?.transitBack()
                            pinDelegate?.onSuccess(target)
                        } else {
                            // Show error retape
                            viewDelegate?.setupPin("Wrong pin code, retry")
                        }
                    } else {
                        self.newPin = pin
                        
                        // Setup UI for second time
                        // ..
                        viewDelegate?.setupPin("Confirm new pin code")
                    }
                case .change:
                    if pin == currentPin {
                        pinMode = .set
                        
                        // Setup UI
                        viewDelegate?.setupPin("Enter new pin code")
                    } else {
                        // Show error retape
                        viewDelegate?.setupPin("Wrong pin code, retry")
                    }
                }
            }
        }
    }
    
    func didPushClose() {
        router?.transitBack()
    }
}
