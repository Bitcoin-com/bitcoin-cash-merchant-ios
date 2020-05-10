//
//  GetRateInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

class GetRateInteractor {
    
    func getRate(withCurrency currency: CountryCurrency) -> StoreRate? {
        let realm = try! Realm()
        let rate = realm.object(ofType: StoreRate.self, forPrimaryKey: currency.currency)
        return rate
    }
}
