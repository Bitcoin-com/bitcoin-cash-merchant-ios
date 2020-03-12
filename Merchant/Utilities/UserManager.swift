//
//  UserManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

final class UserManager {
    
    // MARK: - Properties
    static let shared = UserManager()
    private let defaults = UserDefaults.merchant
    var destination: String? {
        get {
            defaults.value(forKey: Constants.DESTINATION_KEY) as? String
        }
        set {
            if let newValue = newValue {
                defaults.setValue(newValue.trimmingCharacters(in: .whitespaces), forKey: Constants.DESTINATION_KEY)
            } else {
                defaults.removeObject(forKey: Constants.DESTINATION_KEY)
            }
        }
    }
    var companyName: String? {
        get {
            defaults.value(forKey: Constants.COMPANY_NAME_KEY) as? String
        }
        set {
            if let newValue = newValue {
                defaults.setValue(newValue, forKey: Constants.COMPANY_NAME_KEY)
            } else {
                defaults.removeObject(forKey: Constants.COMPANY_NAME_KEY)
            }
        }
    }
    var pin: String? {
        get {
            defaults.value(forKey: Constants.PIN_KEY) as? String
        }
        set {
            if let newValue = newValue {
                defaults.setValue(newValue, forKey: Constants.PIN_KEY)
            } else {
                defaults.removeObject(forKey: Constants.PIN_KEY)
            }
        }
    }
    var selectedCurrency: CountryCurrency {
        get {
            return getCountryCurrency()
        }
        set {
            do {
               let data = try JSONEncoder().encode(newValue)
                defaults.set(data, forKey: Constants.SELECTED_CURRENCY_KEY)
            } catch {
                Logger.log(message: "Storing currency error: \(error.localizedDescription)", type: .error)
            }
        }
    }
    var hasPin: Bool {
        return pin != nil
    }
    var hasDestinationAddress: Bool {
        return destination != nil
    }
    var activeInvoice: InvoiceStatus? {
        get {
            if let data = defaults.data(forKey: Constants.ACTIVE_INVOICE_KEY) {
                return try? JSONDecoder().decode(InvoiceStatus.self, from: data)
            }
            
            return nil
        }
        set {
            if newValue == nil {
                defaults.removeObject(forKey: Constants.ACTIVE_INVOICE_KEY)
            }
            
            if let invoice = newValue {
                if let data = try? JSONEncoder().encode(invoice) {
                    defaults.set(data, forKey: Constants.ACTIVE_INVOICE_KEY)
                }
            }
        }
    }
    var activePaymentTarget: PaymentTarget? {
        get {
            if let data = defaults.data(forKey: Constants.ACTIVE_PAYMENT_TARGET_KEY) {
                return try? JSONDecoder().decode(PaymentTarget.self, from: data)
            }
            
            if let destination = destination {
                let paymentTarget = PaymentTarget(address: destination, type: .address)
                
                if paymentTarget.type != .invalid {
                    if let data = try? JSONEncoder().encode(paymentTarget) {
                        defaults.set(data, forKey: Constants.ACTIVE_PAYMENT_TARGET_KEY)
                    }
                    
                    return paymentTarget
                }
            }
            
            return nil
        }
        set {
            if newValue == nil {
                defaults.removeObject(forKey: Constants.ACTIVE_PAYMENT_TARGET_KEY)
            }
            
            if let paymentTarget = newValue {
                if let data = try? JSONEncoder().encode(paymentTarget) {
                    defaults.set(data, forKey: Constants.ACTIVE_PAYMENT_TARGET_KEY)
                }
            }
        }
    }
    var isTermsAccepted: Bool {
        get {
            return defaults.bool(forKey: Constants.TERMS_ACCEPTED_KEY)
        }
        set {
            defaults.set(newValue, forKey: Constants.TERMS_ACCEPTED_KEY)
        }
    }
    var xPubKeyIndex: Int {
        get {
            return defaults.integer(forKey: Constants.X_PUB_KEY_INDEX)
        }
        set {
            Logger.log(message: "New xPubKey index: \(newValue)", type: .info)
            defaults.set(newValue, forKey: Constants.X_PUB_KEY_INDEX)
        }
    }
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Private API
    private func getCountryCurrency() -> CountryCurrency {
        // If user stored his default currency.
        if let data = defaults.data(forKey: Constants.SELECTED_CURRENCY_KEY) {
            return try! JSONDecoder().decode(CountryCurrency.self, from: data)
        }
        
        // Try to use currency from Locale.current.languageCode.
        if let currency = CurrencyManager.shared.currencyFromLocale() {
            return currency
        }
        
        return CurrencyManager.shared.defaultCurrency()
    }
    
}

private struct Constants {
    static let DESTINATION_KEY = "destination"
    static let COMPANY_NAME_KEY = "companyName"
    static let PIN_KEY = "pin"
    static let SELECTED_CURRENCY_KEY = "selectedCurrency"
    static let ACTIVE_INVOICE_KEY = "activeInvoice"
    static let ACTIVE_PAYMENT_TARGET_KEY = "activePaymentTarget"
    static let TERMS_ACCEPTED_KEY = "termsAccepted"
    static let X_PUB_KEY_INDEX = "xPubKeyIndex"
}
