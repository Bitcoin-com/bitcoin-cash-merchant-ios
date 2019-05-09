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
        
        if UserManager.shared.destination != nil {
            viewDelegate?.hideAlertSettings()
        } else {
            viewDelegate?.showAlertSettings()
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
        self.router?.transitToSettings()
    }
    
    func didPushValid(_ rawAmount: String) {
        // Create payment request
        guard let destination = UserManager.shared.destination
            , let address = try? destination.toCashAddress() else {
            return
        }
        
        let amountInFiat = amountToDouble(rawAmount)

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

    func amountToDouble(_ input: String) -> Double {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale.current
        let n = f.number(from: input.replacingOccurrences(of: ",", with: f.decimalSeparator))
        let dv : Double = n?.doubleValue ?? 0
        return dv
    }
    
    func doubleToCurrency(_ amount: Double) -> String{
        let f = NumberFormatter()
        f.locale = Locale.current
        f.numberStyle = .currency
        if (selectedCurrency.symbol.count > 0) {
            f.currencySymbol = selectedCurrency.symbol
        }
        f.currencyCode = selectedCurrency.ticker;
        return f.string(from: NSNumber(value: amount))!
    }

    fileprivate func setupAmount() {
        let d = amountToDouble(currentRawAmount)
        viewDelegate?.onSetAmount(doubleToCurrency(d))
    }
}
