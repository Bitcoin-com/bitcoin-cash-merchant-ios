//
//  String+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import BitcoinKit

extension String {
    
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        return String(self[start ..< end])
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
	
    func toLegacy() throws -> String {
        return try createAddress(self).legacy
    }
    
    private func createAddress(_ plainAddress: String) throws -> Address {
        do {
            var formattedAddress = plainAddress
            if(formattedAddress.starts(with: "bitcoincash:") == false) {
                formattedAddress = "bitcoincash:\(plainAddress)"
            }
            return try BitcoinAddress(cashaddr: formattedAddress)
        } catch AddressError.invalid {
            return try BitcoinAddress(legacy: plainAddress)
        } catch let e {
            throw e
        }
    }
}
