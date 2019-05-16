//
//  String+Extensions.swift
//  Merchant
//
//  Copyright © 2019 Jean-Baptiste Dominguez
//  Copyright © 2019 Bitcoin.com
//

import BitcoinKit

extension String {
    
    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
    
    func toCashAddress() throws -> String {
        return try AddressFactory.create(self).cashaddr
    }
    
    func toLegacy() throws -> String {
        return try AddressFactory.create(self).base58
    }
    
    func toSatoshis() -> Int64 {
        return Double(self)?.toSatoshis() ?? 0
    }
    
    func toDouble() -> Double {
        // return Double(self.replacingOccurrences(of: ",", with: ".")) ?? 0
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale.current
        let n = f.number(from: self.replacingOccurrences(of: ",", with: f.decimalSeparator))
        let dv : Double = n?.doubleValue ?? 0
        return dv
    }
    
    func toFormat(_ ticker: String, symbol: String, strict: Bool = true) -> String {
        var str = self
        var bothSide: [String.SubSequence]
        if str.contains(",") {
            bothSide = str.split(separator: ",")
        } else {
            bothSide = str.split(separator: ".")
        }
        let leftSide = bothSide[0].description
        
        // Have right side with 2 numbers
        var rightSideStr = bothSide.count > 1 ? bothSide[1].description : ""
        if strict {
            while rightSideStr.count < 2 {
                rightSideStr.append("0")
            }
        }
        
        let characters:[Character] = leftSide.reversed()
        var fiatFormat:[Character] = characters.reversed()
        var numOfSpace = 0
        for (i, _) in characters.enumerated() {
            if i>0 && i%3 == 0 {
                fiatFormat.insert(" ", at: fiatFormat.count - i - numOfSpace)
                numOfSpace = numOfSpace + 1
            }
        }
        
        let leftSideStr = String(fiatFormat)
        
        switch symbol {
        case "$":
//            if leftSideStr == "0" && rightSideStr == "00" {
//                str = "< $ 0,01"
//            } else {
                str = "\(symbol) \(leftSideStr)"
                if rightSideStr.count > 0 {
                    str = "\(str).\(rightSideStr)"
                }
//            }
            break
        case "¥":
            str = "\(leftSideStr) \(symbol)"
            break
        default:
//            if leftSideStr == "0" && rightSideStr == "00" {
//                str = "< 0,01 €"
//            } else {
                str = "\(leftSideStr)"
                if rightSideStr.count > 0 {
                    str = "\(str).\(rightSideStr)"
                }
                str = "\(str) \(symbol)"
//            }
            break
        }
        
        return str
    }
}
