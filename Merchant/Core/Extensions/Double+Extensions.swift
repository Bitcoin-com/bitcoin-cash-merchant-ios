//
//  Double+Extensions.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

extension Double {
    func toSatoshis() -> Int64 {
        return Int64(self*100000000)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
