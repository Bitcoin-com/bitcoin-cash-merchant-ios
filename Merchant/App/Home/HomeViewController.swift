//
//  HomeViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

class HomeViewController: UITabBarController {

    var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paymentController = PaymentInputBuilder().provide()
        paymentController.tabBarItem = UITabBarItem(title: Constants.Strings.payment, image: UIImage(named: "payment_icon"), tag: 0)
        
        let txsController = TransactionsBuilder().provide()
        txsController.tabBarItem = UITabBarItem(title: Constants.Strings.history, image: UIImage(named: "transactions_icon"), tag: 0)
        
        viewControllers = [paymentController, txsController]
        
        tabBar.tintColor = BDCColor.green.uiColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), style: .plain, target: self, action: #selector(didPushSettings))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }
    
    @objc func didPushSettings() {
        presenter?.didPushSettings()
    }
    
    func onCompanyName(_ companyName: String) {
        title = companyName
    }
}
