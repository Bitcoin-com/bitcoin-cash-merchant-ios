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

        view.addSubview(amountView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][c0]", options: .alignAllLeft, metrics: nil, views: ["v0": amountView, "c0": pinCollectionView]))
        pinCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive =  true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .alignAllTop, metrics: nil, views: ["v0": amountView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .alignAllTop, metrics: nil, views: ["v0": pinCollectionView]))
        
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
