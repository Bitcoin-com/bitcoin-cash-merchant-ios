//
//  PaymentRequestViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentRequestViewController: BDCViewController {
    
    var presenter: PaymentRequestPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Payment request"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        
        //
        //
    }
    
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
}
