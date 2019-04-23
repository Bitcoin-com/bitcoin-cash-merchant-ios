//
//  TransactionsPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/06.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

struct TransactionOutput {
    var date: String
    var amountFiat: String
    var amountSatoshis: String
}

class TransactionsPresenter {
    
    var transactionsInteractor: TransactionsInteractor?
    weak var viewDelegate: TransactionsViewController?
    
    func viewDidLoad() {
        // Actual code to fetch the transactions
//        guard let transactions = transactionsInteractor?.getTransactions() else {
//            return
//        }
//
//        let outputs = transactions.flatMap { tx -> TransactionOutput in
//            return TransactionOutput(amountFiat: Double(tx.amount), amountSatoshis: tx.amount)
//        }

        // Get random data to work on the UI
        var outputs = [TransactionOutput]()
        
        Array(0...20).forEach { i in
            outputs.append(TransactionOutput(date: "Today at \(i):00", amountFiat: "$ 100,00", amountSatoshis: "0.00012 BCH"))
        }

        viewDelegate?.onGetTransactions(outputs)
    }
    
}
