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
        guard let multiplier = Decimal(string: "100000000") else {
            return Int64(self*100000000)
        }
        
        let multiplicand = Decimal(floatLiteral: self)
        let product = multiplicand * multiplier
        let productDouble = NSDecimalNumber(decimal: product).doubleValue
        return Int64(productDouble)
    }
    
    func toBCH() -> Double {
        guard let divisor = Decimal(string: "100000000") else {
            return self / 100000000
        }
        
        let dividend = Decimal(floatLiteral: self)
        let quotient = dividend / divisor
        return (quotient as NSDecimalNumber).doubleValue
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
