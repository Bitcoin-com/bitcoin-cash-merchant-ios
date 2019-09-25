//
//  PinController.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

class PinController: PinViewController {

    let pinMessageLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)

        return label
    }()

    let pinView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
        pinCodeStack.axis = .horizontal
        pinCodeStack.alignment = .center
        pinCodeStack.spacing = 16
        pinCodeStack.translatesAutoresizingMaskIntoConstraints = false
        
        pinView.addSubview(pinCodeStack)
        pinCodeStack.centerXAnchor.constraint(equalTo: pinView.centerXAnchor).isActive =  true
        pinCodeStack.bottomAnchor.constraint(equalTo: pinView.bottomAnchor).isActive =  true
        
        pinView.addSubview(pinMessageLabel)
        pinMessageLabel.leadingAnchor.constraint(equalTo: pinView.leadingAnchor).isActive =  true
        pinMessageLabel.trailingAnchor.constraint(equalTo: pinView.trailingAnchor).isActive = true
        pinMessageLabel.topAnchor.constraint(equalTo: pinView.topAnchor).isActive =  true
        pinMessageLabel.bottomAnchor.constraint(equalTo: pinCodeStack.topAnchor, constant: -32).isActive =  true
        
        let headerView = UIView()
        headerView.addSubview(pinView)
        pinView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive =  true
        pinView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8).isActive = true
        pinView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive =  true

        let stackView = UIStackView(arrangedSubviews: [headerView, pinCollectionView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        view.addSubview(stackView)

        stackView.fillSuperView(true, withPadding: 0)
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
