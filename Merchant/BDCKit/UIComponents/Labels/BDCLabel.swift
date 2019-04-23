//
//  BDCLabel.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/11.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCLabel: UILabel {
    
    static func build(_ type: BDCLabelType, frame: CGRect = CGRect.zero) -> BDCLabel {
        let label = BDCLabel(frame: frame)
        label.setup(type)
        return label
    }
    
    func setup(_ type: BDCLabelType) {
        textColor = type.color
        font = type.font
    }
}
