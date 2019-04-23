//
//  PaymentViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentViewController: PinViewController {
    
    var amountLabel: BDCLabel = {
        let label = BDCLabel.build(.title)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var amountView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var presenter: PaymentPresenter?
    
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
        
        self.pinDelegate = self
        
        onPushPin(amount: "0")
    }
    
    func onGetAmount(_ amount: String) {
        amountLabel.text = amount
    }
    
}

extension PaymentViewController: PinViewControllerDelegate {
    func onPushValid(amount: String) {
        presenter?.didPushValid(amount)
    }
    
    
    func onPushPin(amount: String) {
        presenter?.setAmount(amount)
    }
}
