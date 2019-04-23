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
    
    func didPushValid(_ amount: String) {
        // TODO: Calculate amount of Satoshis
        // Create payment request
        guard let destination = UserManager.shared.destination
            , let address = try? destination.toCashAddress() else {
            // TODO: Handle the error here with a message
            return
        }
        
        let pr = PaymentRequest(toAddress: address, amountInSatoshis: 1000, amountInCurrency: 10.10)
        router?.transitToPaymentDetail(pr)
    }
}
