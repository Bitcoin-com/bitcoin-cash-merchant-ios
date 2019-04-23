//
//  PaymentBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/18.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentBuilder: BDCBuilder {
    
    func provide() -> UIViewController {
        let viewController = PaymentViewController()
        
        let router = PaymentRouter(viewController)
        
        let presenter = PaymentPresenter()
        
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
