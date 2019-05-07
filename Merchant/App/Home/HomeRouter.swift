//
//  HomeRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

class HomeRouter: BDCRouter {
    
    func transitToSettings() {
        SecureAccessService.transitTo({ [weak self] in
            let settingsViewController = SettingsBuilder().provide()
            let navViewController = UINavigationController(rootViewController: settingsViewController)
            self?.viewController?.present(navViewController, animated: true, completion: nil)
        })
    }
}
