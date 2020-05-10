//
//  StoreRate.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import RealmSwift

class StoreRate: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id: String = ""
    @objc dynamic var rate: Double = 0.0
    @objc dynamic var updatedAt: Int = 0
}


