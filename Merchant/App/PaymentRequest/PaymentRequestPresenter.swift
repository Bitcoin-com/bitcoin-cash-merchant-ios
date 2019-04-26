//
//  PaymentRequestPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

class PaymentRequestPresenter {
    
    var router: PaymentRequestRouter?
    
    weak var viewDelegate: PaymentRequestViewController?
    
    var paymentRequest: PaymentRequest
    
    init(_ paymentRequest: PaymentRequest) {
        self.paymentRequest = paymentRequest
        print(paymentRequest.amountInCurrency)
        print(paymentRequest.amountInSatoshis)
        print(paymentRequest.toAddress)
    }
    
    func viewDidLoad() {
    }
    
    func didPushClose() {
        router?.transitBackTo()
    }
}
