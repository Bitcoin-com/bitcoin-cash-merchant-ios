//
//  PinBuilder.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

enum PinMode {
    case set
    case change
    case verify
}

class PinBuilder {
    
    func provide(_ pinMode : PinMode, pinDelegate: PinDelegate? = nil, target: String? = nil) -> UIViewController {
        let viewController = PinController()
        let router = PinRouter(viewController)
        let presenter = PinPresenter(pinMode, target: target)
        
        presenter.pinDelegate = pinDelegate
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}


