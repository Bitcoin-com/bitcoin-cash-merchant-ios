//
//  PaymentRequestRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import BDCKit

class PaymentRequestRouter: BDCRouter {
    
    func transitBackTo() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func transitToAmountMismatched(receivedAmount: Int64, expectedAmount: Int64) {
        let vc = AmountMismatchedBuilder().provide(expectedAmount: expectedAmount, receivedAmount: receivedAmount)
        let navController = UINavigationController(rootViewController: vc)
        viewController?.present(navController, animated: true, completion: nil)
    }
}
