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
    
    weak var presenter: PaymentRequestPresenter?
    
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
                .subscribe(onNext: { [weak self] transaction in
                    
                    if let checkAmount = self?.isIncorrectAmount(transaction: transaction,
                                                                 pr: pr,
                                                                 legacyAddress: legacyAddress),
                        checkAmount.isIncorrectAmount {
                        self?.showIncorrectAmountAlert(receivedAmount: checkAmount.receivedAmount,
                                                       expectedAmount: pr.amountInSatoshis)
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
                    
                    self?.saveTransaction(txId: transaction.txid, pr: pr, realm: realm)
                    single(.success(true))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
        
    }
    
    // MARK: - Private
    /*
     * Check if overpaid/underpaid
     */
    fileprivate func isIncorrectAmount(transaction: SocketService.WebSocketTransactionResponse,
                                       pr: PaymentRequest,
                                       legacyAddress: String) -> (isIncorrectAmount: Bool, receivedAmount: Int64) {
        let amount = transaction.outputs
            .filter({ $0.address == legacyAddress })
            .reduce(0, { $0 + $1.value })
        
        return (pr.amountInSatoshis != amount, Int64(amount))
    }
    
    /*
     * Show Alert if overpaid/underpaid
     */
    fileprivate func showIncorrectAmountAlert(receivedAmount: Int64, expectedAmount: Int64) {
        let diff = receivedAmount - expectedAmount
        let message = diff > 0 ? "You overpaid by \(diff)" :
        "You didn’t pay the full amount, you underpaid by \(UInt(diff))"
        
        self.presenter?.showTransactionAlert(title: "", message: message, isSuccess: true)
    }
    
    /*
     * Save Transaction locally
     */
    fileprivate func saveTransaction(txId: String, pr: PaymentRequest, realm: Realm?) {
        let newRealm: Realm = (realm == nil) ? try! Realm() : realm!

        let storeTransaction = StoreTransaction()
        storeTransaction.amountInFiat = pr.amountInFiat
        storeTransaction.amountInSatoshis = pr.amountInSatoshis
        storeTransaction.toAddress = pr.toAddress
        storeTransaction.txid = txId
        storeTransaction.date = Date()
        
        try! newRealm.write {
            newRealm.add(storeTransaction)
        }
    }
}
