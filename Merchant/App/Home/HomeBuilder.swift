//
//  HomeBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class HomeBuilder: BDCBuilder {
    
    func provide() -> UIViewController {
        let viewController = HomeViewController()
        
        let router = HomeRouter(viewController)
        
        let presenter = HomePresenter()
        
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
