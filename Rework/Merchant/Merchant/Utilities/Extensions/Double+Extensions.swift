//
//  Double+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/23/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension Double {
    
    func toSatoshis() -> Int64 {
        let multiplier = Decimal(100_000_000)
        let multiplicand = Decimal(floatLiteral: self)
        let product = multiplicand * multiplier
        let productDouble = NSDecimalNumber(decimal: product).doubleValue
        return Int64(productDouble)
    }
    
    func toBCH() -> Double {
        let divisor = Decimal(100_000_000)
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

