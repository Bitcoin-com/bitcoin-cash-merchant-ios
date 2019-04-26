//
//  Int+Extensions.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

extension Int64 {
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toBCH() -> Double {
        return self.toDouble()/100000000
    }
}
