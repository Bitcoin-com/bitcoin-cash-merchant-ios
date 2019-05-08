//
//  ScannerRouter.swift
//  SLPWalletDemo
//
//  Created by Angel Mortega on 2019/03/20.
//  Contributors Jean-Baptiste Dominguez.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import BDCKit

class ScannerRouter: BDCRouter {
    
    func transitBack() {
        if let navController = viewController?.parent as? UINavigationController {
            navController.popViewController(animated: true)
        } else {
            viewController?.dismiss(animated: false)
        }
    }
}
