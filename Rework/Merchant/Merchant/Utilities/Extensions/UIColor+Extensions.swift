//
//  UIColor+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let blockchainNavigationBar = UIColor("#FF0000")
    static let textColorPrimary = UIColor("#FF0000")
    static let textColorSecondary = UIColor("#FF2222")
    static let blockchainGray = UIColor("#A0A0A0")
    static let white50 = UIColor("#80FFFF")
    static let dropShadowGray = UIColor("#CCCCCC")
    static let bitcoinLightGreen = UIColor("#00D897")
    static let bitcoinGreen = UIColor("#00C58A")
    static let bitcoinDarkerGreen = UIColor("#009B6C")
    static let bitcoinDarkestGreen = UIColor("#00704E")
    
    private convenience init(hex: UInt32) {
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = hex & 0x0000FF
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1.0))
    }
    
    convenience init(_ hexString: String) {
        var string: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespaces).uppercased()
        
        if string.hasPrefix("#") {
            string = String(string.suffix(from: string.index(string.startIndex, offsetBy: 1)))
        }
        
        // Check if the string has exactly 6 characters. If less or more, return white color.
        if string.count != 6 {
            self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            let scanner = Scanner(string: string)
            var hexValue = UInt64(0)
            scanner.scanHexInt64(&hexValue)
            
            self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(hexValue & 0x0000FF) / 255.0, alpha: 1.0)
        }
    }
    
}
