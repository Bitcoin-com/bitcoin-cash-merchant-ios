//
//  BDCColor.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/11.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

enum BDCColor {
    case warmGrey
    case white
    case whiteTwo
    case clearBlue
    case black
    case green
}

extension BDCColor {
    var uiColor: UIColor {
        switch self {
        case .warmGrey:
            return UIColor(displayP3Red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
        case .white:
            return UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case .whiteTwo:
            return UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        case .clearBlue:
            return UIColor(displayP3Red: 41/255, green: 152/255, blue: 242/255, alpha: 1)
        case .black:
            return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        case .green:
            return UIColor(red: 146/256, green: 192/256, blue: 113/256, alpha: 1)
        }
    }
}
