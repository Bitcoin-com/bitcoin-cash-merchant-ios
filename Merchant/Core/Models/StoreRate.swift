//
//  StoreRate.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import RealmSwift

class StoreRate: Object {
    @objc dynamic var currency: StoreCurrency?
    @objc dynamic var rateInSatoshis: Int = 0
    @objc dynamic var updatedAt: Date = Date.init()
}


