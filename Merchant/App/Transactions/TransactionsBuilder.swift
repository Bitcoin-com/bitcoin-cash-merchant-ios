//
//  TransactionsBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/04.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class TransactionsBuilder: BDCBuilder {
    
    func provide() -> UIViewController {
        let viewController = TransactionsViewController()
        
        let transactionsInteractor = TransactionsInteractor()
        let presenter = TransactionsPresenter()
        
        presenter.transactionsInteractor = transactionsInteractor
        presenter.viewDelegate = viewController
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
