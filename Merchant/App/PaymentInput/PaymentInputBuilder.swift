//
//  PaymentInputBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/18.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentInputBuilder: BDCBuilder {
    
    func provide() -> UIViewController {
        let viewController = PaymentInputViewController()
        
        let router = PaymentInputRouter(viewController)
        
        let presenter = PaymentInputPresenter()
        
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
