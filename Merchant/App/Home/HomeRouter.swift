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
        let settingsViewController = SettingsBuilder().provide()
        let navViewController = UINavigationController(rootViewController: settingsViewController)
        viewController?.present(navViewController, animated: true, completion: nil)
    }
}
