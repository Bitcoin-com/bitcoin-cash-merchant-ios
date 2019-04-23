//
//  StoreTransaction.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import RealmSwift

class StoreTransaction: Object {
    @objc dynamic var toAddress: String = ""
    @objc dynamic var txid: String = ""
    @objc dynamic var amountInSatoshis: Int64 = 0
    @objc dynamic var amountInFiat: String = ""
    @objc dynamic var date: Date = Date()
}
