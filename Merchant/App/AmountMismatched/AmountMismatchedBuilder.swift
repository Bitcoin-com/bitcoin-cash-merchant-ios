//
//  AmountMismatchedBuilder.swift
//  Merchant
//
//  Created by Jennifer Eve Curativo on 23/09/2019.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class AmountMismatchedBuilder {
    func provide(expectedAmount: Int64, receivedAmount: Int64) -> AmountMismatchedViewController {
        let viewController = AmountMismatchedViewController()
        let presenter = AmountMismatchedPresenter(expectedAmount: expectedAmount,
                                                  receivedAmount: receivedAmount)
        let router = AmountMismatchedRouter(viewController)
        
        presenter.viewDelegate = viewController
        presenter.router = router
        viewController.presenter = presenter
        
        return viewController
    }
}
