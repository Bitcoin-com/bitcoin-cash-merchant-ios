//
//  UIFont+Helpers.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/13/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Family: String {
        case gilroy = "Gilroy"
    }
    
    enum Style: String {
        case bold = "Bold"
    }
    
    static func custom(family: Family = .gilroy, style: Style, size: CGFloat) -> UIFont {
        let name = String(format: "%@-%@", family.rawValue, style.rawValue)
        
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
