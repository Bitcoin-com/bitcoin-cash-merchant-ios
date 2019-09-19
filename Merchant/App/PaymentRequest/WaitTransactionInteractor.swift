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
                    self?.saveTransaction(txId: transaction.txid, pr: pr)
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
    fileprivate func saveTransaction(txId: String, pr: PaymentRequest) {
        var transactionId = txId
        
        let realm = try! Realm()
        let numberOfResult = realm
            .objects(StoreTransaction.self)
            .filter("txid = %@", transactionId)
            .count
        
        if numberOfResult > 0 {
            // For some reasons, the txId already existed
            // Need to modify the transactionId so it doesn't crash the local db
            transactionId = "\(transactionId)-\(numberOfResult)"
            debugPrint("txId: ", txId)
            debugPrint("transactionId: ", transactionId)
        }

        let storeTransaction = StoreTransaction()
        storeTransaction.amountInFiat = pr.amountInFiat
        storeTransaction.amountInSatoshis = pr.amountInSatoshis
        storeTransaction.toAddress = pr.toAddress
        storeTransaction.txid = transactionId
        storeTransaction.date = Date()
        
        try! realm.write {
            realm.add(storeTransaction)
        }
    }
}
