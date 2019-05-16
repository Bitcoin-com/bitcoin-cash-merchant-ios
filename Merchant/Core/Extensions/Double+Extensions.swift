//
//  Double+Extensions.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

extension Double {
    func toSatoshis() -> Int64 {
        return Int64(self*100000000)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func toCurrency() -> String {
        let f = NumberFormatter()
        f.locale = Locale.current
        let selectedCurrency = UserManager.shared.selectedCurrency
        let locales = RateManager.shared.currencyToCountryLocales?[selectedCurrency.ticker]
        if let locales = locales {
            if locales.count > 0 {
                let locales = locales[0].locales.components(separatedBy:",")
                if (locales.count > 0) {
                    let locale = locales[0].replacingOccurrences(of: "-", with: "_")
                    f.locale = Locale(identifier: locale)
                }
            }
        }
        f.numberStyle = .currency
        if (selectedCurrency.symbol.count > 0) {
            f.currencySymbol = selectedCurrency.symbol
        }
        f.currencyCode = selectedCurrency.ticker;
        return f.string(from: NSNumber(value: self))!
    }
    
    

}
