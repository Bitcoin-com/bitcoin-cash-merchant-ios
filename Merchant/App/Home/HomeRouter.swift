//
//  HomeRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class HomeRouter: BDCRouter {
    
    func transitToSettings() {
        let pinViewController = PinBuilder().provide(.verify, pinDelegate: self, target: "settings")
        viewController?.present(pinViewController, animated: true, completion: nil)
    }
}

extension HomeRouter: PinDelegate {
        
    func onSuccess(_ target: String?) {
        switch target {
        case "settings":
            let settingsViewController = SettingsBuilder().provide()
            let navViewController = UINavigationController(rootViewController: settingsViewController)
            viewController?.present(navViewController, animated: true, completion: nil)
        default: break
        }
    }
    
    func onFailure() {
        // ..
    }
}
