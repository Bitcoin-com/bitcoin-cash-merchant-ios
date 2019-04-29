//
//  WaitTransactionInteractor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import SwiftWebSocket

class WaitTransactionInteractor {
    
    enum WaitTransactionInteractorError: Error {
        case wrongAmount
    }
    
    fileprivate let bag = DisposeBag()
    
    func waitTransaction(withPr pr: PaymentRequest) -> Single<Bool> {
        
        return Single<Bool>.create { single -> Disposable in
            
            let legacyAddress = try! pr.toAddress.toLegacy()
            
            let disposable = SocketService
                .shared
                .observeAddress(withAddress: legacyAddress)
                .subscribe(onNext: { transaction in
                    
                    let amount = transaction.outputs
                        .filter({ $0.address == legacyAddress })
                        .reduce(0, { $0 + $1.value })
                    
                    guard pr.amountInSatoshis == amount else {
                        // Not the right amount, we wait
                        return
                    }
                    
                    let realm = try! Realm()
                    let numberOfResult = realm
                        .objects(StoreTransaction.self)
                        .filter("txid = %@", transaction.txid)
                        .count
                    
                    guard numberOfResult == 0 else {
                        // Parasite, we wait
                        return
                    }
                    
                    let storeTransaction = StoreTransaction()
                    storeTransaction.amountInFiat = pr.amountInFiat
                    storeTransaction.amountInSatoshis = pr.amountInSatoshis
                    storeTransaction.toAddress = pr.toAddress
                    storeTransaction.txid = transaction.txid
                    storeTransaction.date = Date()
                    
                    try! realm.write {
                        realm.add(storeTransaction)
                    }
                                        
                    single(.success(true))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
        
    }
}
