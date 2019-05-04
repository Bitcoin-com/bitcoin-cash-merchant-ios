//
//  PinController.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class PinController: PinViewController {
    static let CODE_DIGIT_COUNT: Int = 4
    static let CIRCLE_EMPTY: String = "\u{26AA}";
    static let CIRCLE_FILLED: String = "\u{26AB}";
    
    var pinCodeLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(56)
        return label
    }()

    var pinMessageLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var pinView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var presenter: PinPresenter?
    let pinMode: PinMode
    var pin: String = ""
    // Next value is only used when the user has never
    var pinChangeFirstCode: String = ""
    var pinChangeCodeBeingConfirmed: Bool = false

    init(_ pinMode: PinMode) {
        self.pinMode = pinMode
        super.init(nibName:nil, bundle:nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetAndTryAgain() {
        pin = "";
        pinChangeFirstCode = ""
        pinChangeCodeBeingConfirmed = false;
        updatePinCodeCircles()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePinCodeCircles()
        
        let pinStackView = UIStackView(arrangedSubviews: [pinCodeLabel, pinMessageLabel])
        pinStackView.axis = .vertical
        pinStackView.translatesAutoresizingMaskIntoConstraints = false

        pinView.addSubview(pinStackView)
        pinStackView.centerXAnchor.constraint(equalTo: pinView.centerXAnchor).isActive =  true
        pinStackView.centerYAnchor.constraint(equalTo: pinView.centerYAnchor).isActive =  true

        let stackView = UIStackView(arrangedSubviews: [pinView, pinCollectionView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        view.addSubview(stackView)

        stackView.fillSuperView()

        pinDelegate = self
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
    }
    
    func onValidPin() {
        // TODO
    }
    
    func onInvalidPinError() {
        let alert = UIAlertController(title: Constants.Strings.receivingAddressNotAvailable, message: Constants.Strings.receivingAddressNotAvailableDetails, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: Constants.Strings.ok, style: .default) { _ in
            self.pin = ""
            self.updatePinCodeCircles();
        }
        
        alert.addAction(tryAgainAction)
        
        present(alert, animated: true)
    }
}

extension PinController: PinViewControllerDelegate {
    func onPushValid() {
        // unused
    }

    func onPushPin(_ key: String) {
        if pin.count >= PinController.CODE_DIGIT_COUNT {
            return
        }
        switch key {
        case "del":
            if pin.count >= 1 {
                pin.removeLast()
            }
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            pin.append(key)
            if pin.count == PinController.CODE_DIGIT_COUNT {
                pinCompletelyEntered();
            }
        default:
            break
        }
        updatePinCodeCircles()
    }

    func updatePinCodeCircles() {
        var s : String = ""
        for i in 1...PinController.CODE_DIGIT_COUNT {
            s = (i == 1 ? "" : " " + s)
                + (pin.count >= i ? PinController.CIRCLE_FILLED : PinController.CIRCLE_EMPTY)
        }
        pinCodeLabel.text = s
        updateMessage()
    }
    
    func updateMessage() {
        switch pinMode {
        case PinMode.Set:
            pinMessageLabel.text = pinChangeCodeBeingConfirmed ? "Confirm new pin code" : "Create pin code"
        case PinMode.Change:
            pinMessageLabel.text = pinChangeCodeBeingConfirmed ? "Confirm new pin code" : "Enter new pin code"
        case PinMode.Verify:
            pinMessageLabel.text = "Enter pin code"
        }
    }

    fileprivate func showAlertAndGoBack(_ title: String, _ message: String, _ action: String) {
        let alertAction = UIAlertAction(title: action, style: .default) { _ in
            self.presenter?.router?.transitBack()
        }
        showAlert(title, message, alertAction)
    }
    
    fileprivate func showAlert(_ title: String, _ message: String, _ alertAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func pinCompletelyEntered() {
        switch pinMode {
        case PinMode.Set, PinMode.Change:
            // pin creation or modification
            if !pinChangeCodeBeingConfirmed {
                // User entered 1st pin code
                // switch to confirmation mode
                pinChangeCodeBeingConfirmed = true;
                // record full pin for later comparison
                pinChangeFirstCode = pin;
                // reset value to allow confirmation
                pin = "";
            } else {
                // User entered 2nd pin code
                // verify that confirmation pin matches the first code
                if (pin == pinChangeFirstCode) {
                    // persist the new pin
                    let storageProvider = InternalStorageProvider()
                    storageProvider.setString(pin, key: "pin")
                    UserManager.shared.pin = pin;
                    showAlertAndGoBack("Success", pinMode == PinMode.Set ? "Pin code created" : "PIN code changed", Constants.Strings.ok)
                    presenter?.pinCheckDelegate?.onPinChecked()
                } else {
                    // 1st & 2nd pin code mismatch: cancel change
                    if pinMode == PinMode.Set {
                        showAlert("Mismatching PIN", "The PIN code has not been created",
                                  UIAlertAction(title: "Try again", style: .default) { _ in
                                    self.resetAndTryAgain()
                            })
                    } else if pinMode == PinMode.Change {
                        showAlertAndGoBack("Mismatching PIN", "The PIN code has not been changed", Constants.Strings.cancel)
                    }
                }
            }
        case PinMode.Verify:
            // pin verification
            let checked : Bool = UserManager.shared.pin == pin;
            if (checked) {
                presenter?.pinCheckDelegate?.onPinChecked()
            } else {
                showAlertAndGoBack("Incorrect PIN", "Operation denied", Constants.Strings.cancel)
            }
        }
    }
}
