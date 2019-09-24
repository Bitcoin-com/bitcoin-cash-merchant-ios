//
//  UIScreen+Extensions.swift
//  BitcoinComWallet
//
//  Created by Jennifer Eve Curativo on 11/09/2019.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIScreen {
    public var center: CGRect {
        let centerY = UIScreen.main.bounds.height/2
        let centerX = UIScreen.main.bounds.width/2
        return CGRect(x: centerX, y: centerY, width: 0, height: 0)
    }
    
    public var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public var width: CGFloat {
        return UIScreen.main.bounds.width
    }
}
