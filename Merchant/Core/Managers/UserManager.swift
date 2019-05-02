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
    var pin: String

    init() {
        
        let storageProvider = InternalStorageProvider()
        let ticker = storageProvider.getString("selectedCurrencyTicker") ?? "USD"
        
        let realm = try! Realm()
        selectedCurrency = realm.object(ofType: StoreCurrency.self, forPrimaryKey: ticker) ?? RateManager.shared.defaultCurrency
        
        destination = storageProvider.getString("destination") ?? ""
        companyName = storageProvider.getString("companyName") ?? "Your company name"
        pin = storageProvider.getString("pin") ?? ""
    }
}
