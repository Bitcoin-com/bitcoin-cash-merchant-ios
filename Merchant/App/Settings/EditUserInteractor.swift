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
    private let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    func editSelectedCurrency(_ newCurrency: StoreCurrency) {
        UserManager.shared.setSelectedCurrency(newCurrency)
        notificationCenter.post(name: .currencyChanged, object: newCurrency)
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

extension Notification.Name {
    static var currencyChanged: Notification.Name {
        return .init(rawValue: "EditUserInteractor.currencyChanged")
    }
}
