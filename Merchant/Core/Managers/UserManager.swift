//
//  UserManager.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

class UserManager {
    
    // Singleton
    static let shared = UserManager()
    
    var selectedCurrency: StoreCurrency
    var destination: String
    var companyName: String
    
    fileprivate var _pin: String
    var pin: String { get { return _pin } }

    init() {
        let storageProvider = InternalStorageProvider()
        let ticker = storageProvider.getString("selectedCurrencyTicker") ?? "USD"
        
        let realm = try! Realm()
        selectedCurrency = realm.object(ofType: StoreCurrency.self, forPrimaryKey: ticker) ?? RateManager.shared.defaultCurrency
        
        destination = storageProvider.getString("destination") ?? ""
        companyName = storageProvider.getString("companyName") ?? "Your company name"
        _pin = storageProvider.getString("pin") ?? ""
    }
}

extension UserManager {

    func setPin(_ pin: String) {
        let storageProvider = InternalStorageProvider()
        storageProvider.setString(pin, key: "pin")
        self._pin = pin
    }
}
