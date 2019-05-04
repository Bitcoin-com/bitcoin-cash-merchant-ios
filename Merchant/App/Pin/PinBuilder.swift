//
//  PinBuilder.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

enum PinMode {
    case Set
    case Change
    case Verify
}

class PinBuilder {
    
    func provide(_ pinMode : PinMode, _ pinCheckDelegate: PinCheckDelegate) -> UIViewController {
        let viewController = PinController(pinMode)
        let router = PinRouter(viewController)
        let presenter = PinPresenter()
        
        presenter.pinCheckDelegate = pinCheckDelegate
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}


