//
//  BDCLabelType.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/14.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

enum BDCLabelType {
    case header
    case title
    case subtitle
    case subtitle2
    case subtitle3
}

extension BDCLabelType {
    var font: UIFont {
        switch self {
        case .header:
            return UIFont(name: "SFProDisplay-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        case .title:
            return UIFont(name: "SFProDisplay-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        case .subtitle:
            return UIFont(name: "SFProDisplay-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12)
        case .subtitle2:
            return UIFont(name: "SFProDisplay-Semibold", size: 11) ?? UIFont.boldSystemFont(ofSize: 11)
        case .subtitle3:
            return UIFont(name: "SFProDisplay-Semibold", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
        }
    }
    
    var color: UIColor {
        switch self {
        case .header, .title, .subtitle3:
            return BDCColor.black.uiColor
        case .subtitle, .subtitle2:
            return BDCColor.warmGrey.uiColor
        }
    }
}

