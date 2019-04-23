//
//  PinCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/17.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PinCell: UICollectionViewCell {
    
    var pinButton: UIButton
    
    override init(frame: CGRect) {
        // Create button
        let pinButton = UIButton(frame: frame)
        pinButton.setTitleColor(BDCColor.green.uiColor, for: .normal)
        pinButton.backgroundColor = BDCColor.whiteTwo.uiColor
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Fill attributes
        self.pinButton = pinButton
        
        // Init
        super.init(frame: frame)
        backgroundColor = BDCColor.whiteTwo.uiColor
        
        // Add views + constraints
        addSubview(pinButton)
        pinButton.fillSuperView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
