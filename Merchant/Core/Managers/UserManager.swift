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
    
    fileprivate var _selectedCurrency: StoreCurrency
    var selectedCurrency: StoreCurrency { get { return _selectedCurrency } }
    
    fileprivate var _destination: String?
    var destination: String? { get { return _destination } }
    
    fileprivate var _companyName: String?
    var companyName: String? { get { return _companyName } }
    
    fileprivate var _pin: String?
    var pin: String? { get { return _pin } }

    init() {
        let storageProvider = InternalStorageProvider()
        let ticker = storageProvider.getString("selectedCurrencyTicker") ?? "USD"
        
        let realm = try! Realm()
        _selectedCurrency = realm.object(ofType: StoreCurrency.self, forPrimaryKey: ticker) ?? RateManager.shared.defaultCurrency
        
        _destination = storageProvider.getString("destination")
        _companyName = storageProvider.getString("companyName")
        _pin = storageProvider.getString("pin")
    }
}

extension UserManager {
    
    func setSelectedCurrency(_ selectedCurrency: StoreCurrency) {
        let storageProvider = InternalStorageProvider()
        storageProvider.setString(selectedCurrency.ticker, key: "selectedCurrencyTicker")
        self._selectedCurrency = selectedCurrency
    }
    
    func setDestination(_ destination: String) {
        let storageProvider = InternalStorageProvider()
        storageProvider.setString(destination, key: "destination")
        self._destination = destination
    }
    
    func setCompanyName(_ companyName: String) {
        let storageProvider = InternalStorageProvider()
        storageProvider.setString(companyName, key: "companyName")
        self._companyName = companyName
    }
    
    func setPin(_ pin: String) {
        let storageProvider = InternalStorageProvider()
        storageProvider.setString(pin, key: "pin")
        self._pin = pin
    }
    
    func hasPin() -> Bool {
        return pin != nil
    }
}
