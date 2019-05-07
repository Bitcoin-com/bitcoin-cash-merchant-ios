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
        UserManager.shared.setSelectedCurrency(newCurrency)
    }
    
    func editCompanyName(_ newCompanyName: String) {
        UserManager.shared.setCompanyName(newCompanyName)
    }
    
    func editDestination(_ newDestination: String) -> Bool {
        
        guard let _ = try? AddressFactory.create(newDestination) else {
            return false
        }
        
        UserManager.shared.setDestination(newDestination)
        
        return true
    }
}
