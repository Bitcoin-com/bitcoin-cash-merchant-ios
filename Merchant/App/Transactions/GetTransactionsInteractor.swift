//
//  TransactionsInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/06.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionsInteractor {
    
    func getTransactions() -> [StoreTransaction] {
        let realm = try! Realm()
        
        let results = realm
            .objects(StoreTransaction.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        let transactions = Array(results)
        
        return transactions
    }
}
