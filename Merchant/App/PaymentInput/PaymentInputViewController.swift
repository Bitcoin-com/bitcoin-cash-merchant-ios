//
//  PaymentInputViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentInputViewController: PinViewController {
    
    var amountLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var amountView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var presenter: PaymentInputPresenter?
    
    var amount: Int = 0
    var amountStr: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountView.addSubview(amountLabel)
        amountLabel.centerXAnchor.constraint(equalTo: amountView.centerXAnchor).isActive =  true
        amountLabel.centerYAnchor.constraint(equalTo: amountView.centerYAnchor).isActive =  true

        let stackView = UIStackView(arrangedSubviews: [amountView, pinCollectionView])
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
    
    func onSetAmount(_ amount: String) {
        amountLabel.text = amount
    }
    
    func onSetComma(_ hasComma: Bool) {
        self.hasComma = hasComma
        commaButton?.setTitle(hasComma ? "," : "", for: .normal)
    }
    
    func onAddressError() {
        let alert = UIAlertController(title: "Receiving Address not available", message: "You don't have any address setup.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            self.presenter?.didPushSettings()
        }
        
        alert.addAction(settingsAction)
        
        present(alert, animated: true)
    }
 
}

extension PaymentInputViewController: PinViewControllerDelegate {
    
    func onPushValid() {
        presenter?.didPushValid(amountStr)
    }
    
    
    func onPushPin(_ pin: String) {
        switch pin {
        case ",":
            if amountStr.contains(pin) {
                return
            }
            amountStr.append(pin)
            presenter?.didSetAmount(amountStr)
        case "del":
            if amountStr.count > 1 {
                amountStr.removeLast()
            } else {
                amountStr = "0"
            }
            presenter?.didSetAmount(amountStr)
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if amountStr.count < 1 || amountStr == "0" {
                amountStr = pin
            } else {
                amountStr.append(pin)
            }
            presenter?.didSetAmount(amountStr)
        default: break
        }
    }
}

extension PaymentInputViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(amountLabel.frame)
        return CirclePresentAnimationController(originFrame: amountLabel.frame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(amountLabel.frame)
        return CircleDismissAnimationController(originFrame: amountLabel.frame)
    }
}
