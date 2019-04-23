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
    var receiveButton: BDCButton = {
        let button = BDCButton.build(.type2)
        button.setTitle("Receive", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPushReceive), for: .touchUpInside)
        return button
    }()
    var buttonView: UIView = {
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
        
        buttonView.addSubview(receiveButton)
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[b0]-16-|", options: .alignAllLeft, metrics: nil, views: ["b0": receiveButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[b0]-16-|", options: .alignAllTop, metrics: nil, views: ["b0": receiveButton]))

        view.addSubview(amountView)
        view.addSubview(buttonView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][c0][v1]", options: .alignAllLeft, metrics: nil, views: ["v0": amountView, "c0": pinCollectionView, "v1": buttonView]))
        buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive =  true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .alignAllTop, metrics: nil, views: ["v0": amountView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .alignAllTop, metrics: nil, views: ["v0": buttonView]))
        
        self.pinDelegate = self
        
        onPushPin(amount: "0")
    }
    
    func onGetAmount(_ amount: String) {
        amountLabel.text = amount
    }
    
    @objc func didPushReceive() {
        // TODO: Call the presenter and set the action didPushReceive
    }
    
}

extension PaymentViewController: PinViewControllerDelegate {
    
    func onPushPin(amount: String) {
        presenter?.setAmount(amount)
    }
}
