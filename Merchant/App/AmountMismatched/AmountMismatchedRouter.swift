//
//  AmountMismatchedRouter.swift
//  Merchant
//
//  Created by Jennifer Eve Curativo on 23/09/2019.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import BDCKit

class AmountMismatchedRouter: BDCRouter {
    func transitBackTo() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
