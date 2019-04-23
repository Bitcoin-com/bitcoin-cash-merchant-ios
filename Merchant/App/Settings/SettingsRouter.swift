//
//  SettingsRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class SettingsRouter: BDCRouter {
    
    func transitBack() {
        viewController?.dismiss(animated: true)
    }
}
