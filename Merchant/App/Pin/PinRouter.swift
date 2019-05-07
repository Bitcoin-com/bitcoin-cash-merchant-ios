//
//  PinRouter.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class PinRouter: BDCRouter {
    func transitBack() {
        if let navController = viewController?.parent as? UINavigationController {
            navController.popViewController(animated: true)
        } else {
            viewController?.dismiss(animated: false)
        }
    }
}
