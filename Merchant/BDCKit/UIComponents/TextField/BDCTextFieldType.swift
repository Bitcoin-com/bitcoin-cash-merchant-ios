//
//  BDCTextFieldType.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

enum BDCTextFieldType {
    case type1
}

extension BDCTextFieldType {
    var font: UIFont {
        switch self {
        case .type1:
            return UIFont(name: "SFProDisplay-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12)
        }
    }
    
    var color: UIColor {
        switch self {
        case .type1:
            return BDCColor.warmGrey.uiColor
        }
    }
}


