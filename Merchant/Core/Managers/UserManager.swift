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
    static let shared = UserManager()
    fileprivate let storage = InternalStorageProvider()
    
    // MARK: User Properties
    var destination: String? {
        didSet {
            if destination?.count == 0 {
                destination = nil
            }
            
            (destination == nil) ? storage.remove("destination") : storage.setString(destination!, key: "destination")
        }
    }
    
    var companyName: String? {
        didSet {
            if companyName?.count == 0 {
                companyName = nil
            }
            
            (companyName == nil) ? storage.remove("companyName") : storage.setString(companyName!, key: "companyName")
        }
    }
    
    var pin: String? {
        didSet {
            if pin?.count == 0 {
                pin = nil
            }
            
            (pin == nil) ? storage.remove("pin") : storage.setString(pin!, key: "pin")
        }
    }
    
    var selectedCurrency: StoreCurrency {
        didSet {
            storage.setString(selectedCurrency.ticker, key: "selectedCurrencyTicker")
        }
    }
    
    private init() {
        let ticker = storage.getString("selectedCurrencyTicker") ?? "USD"
        let realm = try! Realm()
        
        selectedCurrency = realm.object(ofType: StoreCurrency.self, forPrimaryKey: ticker) ?? RateManager.shared.defaultCurrency
        destination = storage.getString("destination")
        companyName = storage.getString("companyName")
        pin = storage.getString("pin")
    }
    
    func hasPin() -> Bool {
        return pin != nil
    }
}
