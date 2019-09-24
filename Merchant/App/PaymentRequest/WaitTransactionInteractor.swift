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
    
    fileprivate let bag = DisposeBag()
    
    func waitTransaction(withPr pr: PaymentRequest) -> Single<Bool> {
        
        return Single<Bool>.create { single -> Disposable in
            
            let legacyAddress = try! pr.toAddress.toLegacy()
            
            let disposable = SocketService
                .shared
                .observeAddress(withAddress: legacyAddress)
                .subscribe(onNext: { [weak self] transaction in
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
                    
                    if let isWithinTxBuffer = self?.isWithinTxBuffer(transaction: transaction, pr: pr, legacyAddress: legacyAddress), !isWithinTxBuffer.isWithinTxBuffer {
                        self?.showIncorrectAmountAlert(receivedAmount: isWithinTxBuffer.receivedAmount,
                                                       expectedAmount: pr.amountInSatoshis)
                        single(.success(false))
                    } else {
                        single(.success(true))
                    }
                    
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
        
    }
    
    // MARK: - Private
    /*
     * Check if overpaid/underpaid,
     * If yes, check if it's withint tx buffer
     */
    fileprivate func isWithinTxBuffer(transaction: SocketService.WebSocketTransactionResponse,
                                       pr: PaymentRequest,
                                       legacyAddress: String) -> (isWithinTxBuffer: Bool, receivedAmount: Int64) {
        let amount = transaction.outputs
            .filter({ $0.address == legacyAddress })
            .reduce(0, { $0 + $1.value })
        let receivedAmount = Int64(amount)
        
        if abs(pr.amountInSatoshis - receivedAmount) > Constants.transactionBufferInSatoshis {
            return (false, receivedAmount)
        }

        return (true, receivedAmount)
    }
    
    /*
     * Show Screen if overpaid/underpaid
     */
    fileprivate func showIncorrectAmountAlert(receivedAmount: Int64, expectedAmount: Int64) {
        self.presenter?.showAmountMismatched(receivedAmount: receivedAmount, expectedAmount: expectedAmount)
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
