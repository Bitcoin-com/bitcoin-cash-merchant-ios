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
    
    enum TransactionError: Error {
        case wrongAmount
        case decode
    }
    
    struct WebSocketTransactionResponse: Codable {
        var txid: String
        var fees: Int
        var amount: Int
        var outputs: [WebSocketOutputResponse]
    }
    
    struct WebSocketOutputResponse: Codable {
        var address: String
        var value: Int
    }
    
    func waitTransaction(withPr pr: PaymentRequest) -> Single<Bool> {
        
        return Single<Bool>.create { single -> Disposable in
            
            let legacyAddress = try! pr.toAddress.toLegacy()
            let ws = WebSocket("ws://47.254.143.172:80/v1/address")
            var shouldListen = true
            
            ws.event.open = {
                print("opened")
//                if let data = message.data(using: .utf8) {
//                    print(message)
//                    ws.send(data: data)
//                }
                let message = "{\"op\": \"addr_sub\", \"addr\":\"\(legacyAddress)\"}"
                print(message)
                ws.send(message)
            }
            
            ws.event.close = { code, reason, clean in
                print("close")
                
                if shouldListen {
                    ws.open()
                }
            }
            
            ws.event.error = { error in
                print("error \(error)")
            }
            
            ws.event.message = { message in
                let message = message as? String
                let data = message?.data(using: .utf8)
                
                guard let transaction = try? JSONDecoder().decode(WebSocketTransactionResponse.self, from: data!) else {
                    single(.error(TransactionError.decode))
                        print("fail decoder")
                    return
                }
                
                let amount = transaction.outputs
                    .filter({ $0.address == legacyAddress })
                    .reduce(0, { $0 + $1.value })
                
                guard pr.amountInSatoshis == amount else {
                    single(.error(TransactionError.wrongAmount))
                    return
                }
                
                let storeTransaction = StoreTransaction()
                storeTransaction.amountInFiat = pr.amountInFiat
                storeTransaction.amountInSatoshis = pr.amountInSatoshis
                storeTransaction.toAddress = pr.toAddress
                storeTransaction.txid = transaction.txid
                storeTransaction.date = Date()
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(storeTransaction)
                }
                
                shouldListen = false
                ws.close()
                
                single(.success(true))
                
                //recv: {"txid":"04dc5f2c5c012ef20de56fde1582139c477f7656de33b1342ed003009eabdf41","fees":0,"confirmations":0,"amount":16983,"outputs":[{"address":"3JL2QfYGqb6jbXNUKVY2RES3exxpRZAi1a","value":16983}]}
            }
            
            ws.open()
            
            return Disposables.create()
        }
        
    }
}
