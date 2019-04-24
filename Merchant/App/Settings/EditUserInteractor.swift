//
//  EditUserInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import BitcoinKit

class EditUserInteractor {
    
    fileprivate let storageProvider = InternalStorageProvider()
    
    func editSelectedCurrency(_ newCurrency: StoreCurrency) {
        storageProvider.setString(newCurrency.ticker, key: "selectedCurrencyTicker")
        UserManager.shared.selectedCurrency = newCurrency
    }
    
    func editCompanyName(_ newCompanyName: String) {
        storageProvider.setString(newCompanyName, key: "companyName")
        UserManager.shared.companyName = newCompanyName
    }
    
    func editDestination(_ newDestination: String) -> Bool {
        
        guard let _ = try? AddressFactory.create(newDestination) else {
            return false
        }
        
        storageProvider.setString(newDestination, key: "destination")
        UserManager.shared.destination = newDestination
        
        return true
    }
}
