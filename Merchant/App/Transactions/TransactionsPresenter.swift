//
//  TransactionsPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/06.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

struct TransactionOutput {
    var txid: String
    var date: String
    var amountInFiat: String
    var amountInBCH: String
}

class TransactionsPresenter {
    
    var transactionsInteractor: TransactionsInteractor?
    weak var viewDelegate: TransactionsViewController?
    
    fileprivate var transactions = [StoreTransaction]()
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        setupTransactions()
    }
    
    func setupTransactions() {
        guard let transactions = transactionsInteractor?.getTransactions() else {
            return
        }
        
        if transactions.count != self.transactions.count {
            // Actual code to fetch the transactions
            let outputs = transactions.compactMap { tx -> TransactionOutput in
                
                // Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .medium
                
                // US English Locale (en_US)
                dateFormatter.locale = Locale(identifier: "en_US")
                let dateStr = dateFormatter.string(from: tx.date) // Jan 2, 2001
                
                let amountInBCH = tx.amountInSatoshis.toBCH().description.toFormat("BCH", symbol: "BCH")
                
                return TransactionOutput(txid: tx.txid, date: dateStr, amountInFiat: tx.amountInFiat, amountInBCH: amountInBCH)
            }
            
            viewDelegate?.onGetTransactions(outputs)
        }
        
        self.transactions = transactions
    }
    
    func didPushViewTransaction(forIndex index: Int) {
        let transaction = transactions[index]
        
        guard let url = URL(string: "https://explorer.bitcoin.com/bch/tx/\(transaction.txid)") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func didPushViewAddress(forIndex index: Int) {
        let transaction = transactions[index]
        
        guard let url = URL(string: "https://explorer.bitcoin.com/bch/address/\(transaction.toAddress)") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func didPushCopyTransaction(forIndex index: Int) {
        let transaction = transactions[index]
        
        UIPasteboard.general.string = transaction.txid
        
        viewDelegate?.onSuccessCopy()
    }
    
}
