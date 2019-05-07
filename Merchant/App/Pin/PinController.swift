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

    var pinMessageLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var pinView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = BDCColor.white.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pinCodeImageViews = [UIImageView]()
    
    var pinStr: String = ""
    var presenter: PinPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...3 {
            let pinCodeImageView = UIImageView(image: nil)
            pinCodeImageViews.append(pinCodeImageView)
            pinCodeImageView.layer.cornerRadius = 48/2
            pinCodeImageView.clipsToBounds = true
            pinCodeImageView.backgroundColor = BDCColor.green.uiColor
            pinCodeImageView.translatesAutoresizingMaskIntoConstraints = false
            pinCodeImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            pinCodeImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        let pinCodeStack = UIStackView(arrangedSubviews: pinCodeImageViews)
        pinCodeStack.translatesAutoresizingMaskIntoConstraints = false
        pinCodeStack.axis = .horizontal
        pinCodeStack.alignment = .center
        pinCodeStack.spacing = 16
        
        pinView.addSubview(pinCodeStack)
        pinCodeStack.centerXAnchor.constraint(equalTo: pinView.centerXAnchor).isActive =  true
        pinCodeStack.centerYAnchor.constraint(equalTo: pinView.centerYAnchor).isActive =  true
        
        pinView.addSubview(pinMessageLabel)
        pinMessageLabel.leadingAnchor.constraint(equalTo: pinView.leadingAnchor, constant: 8).isActive =  true
        pinMessageLabel.trailingAnchor.constraint(equalTo: pinView.trailingAnchor, constant: -8).isActive = true
        pinMessageLabel.bottomAnchor.constraint(equalTo: pinCodeStack.topAnchor, constant: -32).isActive =  true

        let stackView = UIStackView(arrangedSubviews: [pinView, pinCollectionView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        view.addSubview(stackView)

        stackView.fillSuperView()
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.backgroundColor = BDCColor.whiteTwo.uiColor
        hasComma = false

        pinDelegate = self
}
    
    func setupPin(_ message: String? = nil) {
        if let message = message {
            pinMessageLabel.text = message
        }
        pinStr = ""
        showPins(pinStr.count)
    }
    
    func showPins(_ number: Int) {
        for (i, pinCodeImageView) in pinCodeImageViews.enumerated() {
            if number <= i {
                pinCodeImageView.image = nil
            } else {
                pinCodeImageView.image = UIImage(named: "bch_icon")
            }
        }
    }
    
    func showAlert(_ title: String, message: String, action: String, actionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: action, style: .default) { _ in
            if let handler = actionHandler {
                handler()
            }
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

extension PinController: PinViewControllerDelegate {
    func onPushPin(_ pin: String) {
        switch pin {
        case "del":
            if pinStr.count > 1 {
                pinStr.removeLast()
            } else {
                pinStr = ""
            }
            presenter?.didSetPin(pinStr)
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            pinStr.append(pin)
            presenter?.didSetPin(pinStr)
        default: break
        }
    }
    
    func onPushValid() {
        // No need
    }
}
