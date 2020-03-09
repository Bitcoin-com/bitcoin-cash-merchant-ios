//
//  Int+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/23/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension Int {
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toBCH() -> Double {
        return self.toDouble().toBCH()
    }
    
    func toBCHFormat() -> String {
        var satoshisStr: [Character] = description.reversed()
        
        while (satoshisStr.count < 9) {
            satoshisStr.append("0")
        }
        
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
    
    func toMinutesSeconds() -> String {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        let minutesString = "\(minutes < 10 ? "0\(minutes)" : "\(minutes)")"
        let secondsString = "\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
        
        return "\(minutesString):\(secondsString)"
    }
    
}

extension Int64 {
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toBCH() -> Double {
        return self.toDouble().toBCH()
    }
    
    func toBCHFormat() -> String {
        var satoshisStr: [Character] = description.reversed()
        
        while (satoshisStr.count < 9) {
            satoshisStr.append("0")
        }
        
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
