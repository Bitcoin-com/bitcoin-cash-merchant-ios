//
//  GetCurrenciesInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

class GetCurrenciesInteractor {
    func getCurrencies() -> [StoreCurrency] {
        let realm = try! Realm()
        let results = realm
            .objects(StoreCurrency.self)
            .sorted(byKeyPath: "name")
        
        let currencies = Array(results)
        return currencies
    }
}
