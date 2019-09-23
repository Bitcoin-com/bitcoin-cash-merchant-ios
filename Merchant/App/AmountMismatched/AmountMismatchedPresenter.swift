//
//  AmountMismatchedPresenter.swift
//  Merchant
//
//  Created by Jennifer Eve Curativo on 23/09/2019.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

class AmountMismatchedPresenter {
    
    var router: AmountMismatchedRouter!
    weak var viewDelegate: AmountMismatchedViewDelegate!

    fileprivate let transactionBufferInSatoshis: Int64 = 1000
    fileprivate var expectedAmountInSatoshis: Int64 = 0
    fileprivate var receivedAmountInSatoshis: Int64 = 0

    init(expectedAmount: Int64, receivedAmount: Int64) {
        self.expectedAmountInSatoshis = expectedAmount
        self.receivedAmountInSatoshis = receivedAmount
    }
    
    func viewDidLoad() {
        checkAmount()
    }
    
    func didPushClose() {
        router.transitBackTo()
    }
    
    fileprivate func checkAmount() {
        let difference = expectedAmountInSatoshis - receivedAmountInSatoshis
        
        if difference > transactionBufferInSatoshis {
            //underpaid
            viewDelegate.showUnderpaid(by: difference)
        } else if difference < -transactionBufferInSatoshis {
            //overpaid
            viewDelegate.showOverpaid(by: difference)
        }
    }
}
