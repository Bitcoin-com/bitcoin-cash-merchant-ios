//
//  PinBuilder.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class PinBuilder {
    
    func provide(_ pinCheckDelegate: PinCheckDelegate) -> UIViewController {
        let viewController = PinController()
        let router = PinRouter(viewController)
        let presenter = PinPresenter()
        
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}


