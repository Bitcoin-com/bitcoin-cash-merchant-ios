//
//  PaymentPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/14.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class PaymentPresenter {
    
    var router: PaymentRouter?
    weak var viewDelegate: PaymentViewController?
    
    func viewDidLoad() {
    }
    
    func setAmount(_ amount: String) {
        // TODO: Manage the rate here
        let amountStr = amount.toFormat("USD", strict: true)
        viewDelegate?.onGetAmount(amountStr)
    }
}
