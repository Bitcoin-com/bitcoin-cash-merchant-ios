//
//  PinCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/17.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

class PinCell: UICollectionViewCell {
    
    var pinButton: UIButton
    
    override init(frame: CGRect) {
        pinButton = UIButton(frame: frame)
        pinButton.setTitleColor(BDCColor.primary.uiColor, for: .normal)
        pinButton.backgroundColor = BDCColor.whiteTwo.uiColor
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        backgroundColor = BDCColor.whiteTwo.uiColor
        
        addSubview(pinButton)
        pinButton.fillSuperView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
