//
//  StoreTransaction.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

final class StoreTransaction: Object {
    
    // MARK: - Properties
    @objc dynamic var toAddress = ""
    @objc dynamic var txid = ""
    @objc dynamic var amountInSatoshis: Int64 = 0
    @objc dynamic var amountInFiat = ""
    @objc dynamic var date = Date()
    
}
