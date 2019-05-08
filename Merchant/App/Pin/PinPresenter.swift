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
    var currentPin: String?
    var newPin: String?
    var pinMode: PinMode
    
    init(_ pinMode: PinMode, target: String?) {
        currentPin = UserManager.shared.pin
        self.pinMode = pinMode
        self.target = target
    }
    
    func viewDidLoad() {
        switch pinMode {
        case .verify:
            viewDelegate?.setupPin(Constants.Strings.enterPinCode)
        case .change:
            viewDelegate?.setupPin(Constants.Strings.enterCurrentPinCode)
        case .set:
            viewDelegate?.setupPin(Constants.Strings.createPinCode)
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
                        viewDelegate?.showAlert(Constants.Strings.incorrectPin, message: Constants.Strings.operationDenied, action: Constants.Strings.cancel, actionHandler: { [weak self] in
                            self?.pinDelegate?.onFailure()
                        })
                    }
                case .set:
                    if let newPin = self.newPin {
                        if pin == newPin {
                            UserManager.shared.setPin(newPin)
                            
                            viewDelegate?.showAlert(Constants.Strings.success, message: Constants.Strings.pinHasBeenChanged, action: Constants.Strings.ok, actionHandler: { [weak self] in
                                self?.router?.transitBack()
                                self?.pinDelegate?.onSuccess(self?.target)
                            })
                        } else {
                            if let _ = currentPin {
                                // Show error
                                viewDelegate?.showAlert(Constants.Strings.mismatchPin, message: Constants.Strings.pinHasNotBeenChanged, action: Constants.Strings.cancel, actionHandler: { [weak self] in
                                    self?.router?.transitBack()
                                    self?.pinDelegate?.onFailure()
                                })
                            } else {
                                // Show error retape
                                viewDelegate?.showAlert(Constants.Strings.mismatchPin, message: Constants.Strings.pinIsRequired, action: Constants.Strings.tryAgain, actionHandler: { [weak self] in
                                    self?.newPin = nil
                                    self?.viewDelegate?.setupPin(Constants.Strings.createPinCode)
                                })
                            }
                        }
                    } else {
                        self.newPin = pin
                        
                        // Setup UI for second time
                        // ..
                        viewDelegate?.setupPin(Constants.Strings.confirmNewPinCode)
                    }
                case .change:
                    if pin == currentPin {
                        pinMode = .set
                        
                        // Setup UI
                        viewDelegate?.setupPin(Constants.Strings.enterNewPinCode)
                    } else {
                        viewDelegate?.showAlert(Constants.Strings.mismatchPin, message: Constants.Strings.cancellingPin, action: Constants.Strings.ok, actionHandler: { [weak self] in
                            self?.router?.transitBack()
                            self?.pinDelegate?.onFailure()
                        })
                    }
                }
            }
        }
    }
    
    func didPushClose() {
        router?.transitBack()
    }
}
