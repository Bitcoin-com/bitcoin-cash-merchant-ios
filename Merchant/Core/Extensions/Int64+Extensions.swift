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
    
    func toBCHFormat() -> String {
        var satoshisStr: [Character] = self.description.reversed()
        
        // Make sure our str has minimum 8 characters
        while (satoshisStr.count < 9) {
            satoshisStr.append("0")
        }
                
        // Then add space when it is needed
        var satoshisStrWithSpace = [Character]()
        satoshisStrWithSpace.insert(satoshisStr.removeFirst(), at: 0)
        satoshisStrWithSpace.insert(satoshisStr.removeFirst(), at: 0)
        
        for i in 0...satoshisStr.count-1 {
            if i%3 == 0 {
                if i == 6 {
                    satoshisStrWithSpace.insert(".", at: 0)
                } else {
                    satoshisStrWithSpace.insert(" ", at: 0)
                }
            }
            satoshisStrWithSpace.insert(satoshisStr[i], at: 0)
        }
        
        return "\(String(satoshisStrWithSpace)) BCH"
    }
}
