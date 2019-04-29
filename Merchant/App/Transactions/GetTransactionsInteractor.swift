//
//  GetTransactionsInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/06.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class GetTransactionsInteractor {
    
    func getTransactions() -> Observable<[StoreTransaction]> {
        let realm = try! Realm()
        
        let transactions = realm
            .objects(StoreTransaction.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        return Observable
            .collection(from: transactions, synchronousStart: true)
            .map({ $0.toArray() })
    }
}
