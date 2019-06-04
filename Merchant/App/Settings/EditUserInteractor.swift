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
    
    func editSelectedCurrency(_ newCurrency: StoreCurrency) {
        UserManager.shared.selectedCurrency = newCurrency
    }
    
    func editCompanyName(_ newCompanyName: String) {
        UserManager.shared.companyName = newCompanyName
    }
    
    func editDestination(_ newDestination: String) -> Bool {
        
        guard let _ = try? AddressFactory.create(newDestination) else {
            return false
        }
        
        UserManager.shared.destination = newDestination
        
        return true
    }
}
