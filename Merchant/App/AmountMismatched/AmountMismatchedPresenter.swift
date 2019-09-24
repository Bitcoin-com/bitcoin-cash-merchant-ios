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
        let txBuffer = Constants.transactionBufferInSatoshis
        
        if difference > txBuffer {
            //underpaid
            viewDelegate.showUnderpaid(by: abs(difference))
        } else if difference < -txBuffer {
            //overpaid
            viewDelegate.showOverpaid(by: abs(difference))
        }
    }
}
