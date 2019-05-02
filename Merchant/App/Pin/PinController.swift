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
    static let CIRCLE_EMPTY: String = "\u{25EF}";
    static let CIRCLE_FILLED: String = "\u{2B24}";
    
    var pinCodeLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(56)
        return label
    }()

    var pinMessageLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter pin code"
        return label
    }()

    var pinView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var presenter: PinPresenter?
    
    var pin: String = ""
    // Next value is only used when the user has never
    var pinBeingChanged: Bool = false
    var pinChangeFirstCode: String = ""
    var pinChangeCodeBeingConfirmed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePinCodeCircles()

        pinView.addSubview(pinCodeLabel)
        pinCodeLabel.centerXAnchor.constraint(equalTo: pinView.centerXAnchor).isActive =  true
        pinCodeLabel.centerYAnchor.constraint(equalTo: pinView.centerYAnchor).isActive =  true

        let stackView = UIStackView(arrangedSubviews: [pinView, pinMessageLabel, pinCollectionView])
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
                pinCompleted();
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
        pinCodeLabel.text = s;
    }

    func pinCompleted() {
        if pinBeingChanged {
            // pin creation or modification
            if !pinChangeCodeBeingConfirmed {
                // switch to confirmation mode
                pinChangeCodeBeingConfirmed = true;
                // record full pin for later comparison
                pinChangeFirstCode = pin;
                // reset value to allow confirmation
                pin = "";
            } else {
                // verify that confirmation pin matches the first entry
                if (pin == pinChangeFirstCode) {
                    // persist the new pin
                    UserManager.shared.pin = pin;
                } else {
                    // 1st and 2nd pin code mismatch: cancel change
                    let alert = UIAlertController(title: "Mismatching PIN", message: "Cancelling PIN code change", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: Constants.Strings.cancel, style: .default) { _ in
                        self.presenter?.router?.transitBack()
                    }
                    alert.addAction(cancelAction)
                    present(alert, animated: true)
                }
            }
        } else {
            // pin verification
            let checked : Bool = UserManager.shared.pin == pin;
            if (checked) {
                presenter?.pinCheckDelegate?.onPinChecked()
            } else {
                let alert = UIAlertController(title: "Incorrect PIN", message: "Operation denied", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: Constants.Strings.cancel, style: .default) { _ in
                    self.presenter?.router?.transitBack()
                }
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
        }
    }
}
