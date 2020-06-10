//
//  StoreCurrency.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import RealmSwift

class StoreCurrency: Object {
    
    override static func primaryKey() -> String? {
        return "ticker"
    }
    
    @objc dynamic var name: String = ""
    @objc dynamic var symbol: String = ""
    @objc dynamic var ticker: String = ""
}

extension StoreCurrency {
    func hasComma() -> Bool {
        switch symbol {
        case "¥":
            return false
        default:
            return true
        }
    }
}
