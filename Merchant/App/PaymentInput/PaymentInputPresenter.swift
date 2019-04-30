//
//  PaymentInputPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/14.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PaymentInputPresenter {
    
    var getRateInteractor: GetRateInteractor?
    var router: PaymentInputRouter?
    weak var viewDelegate: PaymentInputViewController?
    
    var selectedCurrency: StoreCurrency
    var currentRawAmount: String = "0"
    
    init() {
        selectedCurrency = UserManager.shared.selectedCurrency
    }
    
    func viewDidLoad() {
        setupCurrency()
    }
    
    func viewWillAppear() {
        let newCurrency = UserManager.shared.selectedCurrency
        
        if newCurrency != selectedCurrency {
            selectedCurrency = newCurrency
            setupCurrency()
        }
    }
}

extension PaymentInputPresenter: PaymentRequestPresenterDelegate {
    
    func paymentReceived() {
        viewDelegate?.onCleanAmount()
        didSetAmount("0")
    }
}

extension PaymentInputPresenter {
    func didSetAmount(_ rawAmount: String) {
        currentRawAmount = rawAmount
        setupAmount()
    }
    
    func didPushSettings() {
        router?.transitToSettings()
    }
    
    func didPushValid(_ rawAmount: String) {
        // Create payment request
        let destination = UserManager.shared.destination
        guard let address = try? destination.toCashAddress() else {
            viewDelegate?.onAddressError()
            return
        }
        
        let amountInFiat = rawAmount.toDouble()
        
        guard amountInFiat > 0 else {
            return
        }
        
        guard let rate = getRateInteractor?.getRate(withCurrency: selectedCurrency) else {
            // TODO: Handle the error here with a message
            print("error get rate")
            return
        }
        
        let amountInSatoshis = rate.rate > 0  ? (amountInFiat / rate.rate).toSatoshis() : 0
        let amountInFiatStr = rawAmount.toFormat(selectedCurrency.ticker, symbol: selectedCurrency.symbol, strict: true)
        
        let pr = PaymentRequest(toAddress: address, amountInSatoshis: Int64(amountInSatoshis), amountInFiat: amountInFiatStr, selectedCurrency: selectedCurrency)
        router?.transitToPaymentDetail(pr, requestDelegate: self)
    }
}

extension PaymentInputPresenter {
    
    fileprivate func setupCurrency() {
        viewDelegate?.onSetComma(selectedCurrency.hasComma())
        setupAmount()
    }
    
    fileprivate func setupAmount() {
        let amount = currentRawAmount.toFormat(selectedCurrency.ticker, symbol: selectedCurrency.symbol, strict: true)
        viewDelegate?.onSetAmount(amount)
    }
}
