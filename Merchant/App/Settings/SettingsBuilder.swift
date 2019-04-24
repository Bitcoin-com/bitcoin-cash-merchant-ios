//
//  SettingsBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class SettingsBuilder: BDCBuilder {
    
    func provide() -> UIViewController {
        let viewController = SettingsViewController()
        
        let editUserInteractor = EditUserInteractor()
        let router = SettingsRouter(viewController)
        
        let presenter = SettingsPresenter()
        presenter.editUserInteractor = editUserInteractor
        presenter.viewDelegate = viewController
        presenter.router = router
        
        viewController.presenter = presenter
        
        return viewController
    }
}
