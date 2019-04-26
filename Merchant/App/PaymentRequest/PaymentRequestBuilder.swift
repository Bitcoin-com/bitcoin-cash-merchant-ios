//
//  PaymentRequestBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentRequestBuilder {
    
    func provide(_ pr: PaymentRequest) -> UIViewController {
        let viewController = PaymentRequestViewController()
        
        let waitTransactionInteractor = WaitTransactionInteractor()
        let router = PaymentRequestRouter(viewController)
        
        let presenter = PaymentRequestPresenter(pr)
        
        presenter.waitTransactionInteractor = waitTransactionInteractor
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
