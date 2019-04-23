//
//  Button.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/11.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCButton: UIButton {
    
    var type: BDCButtonType?
    var isSetup = false
    
    static func build(_ type: BDCButtonType) -> BDCButton {
        let button = BDCButton(type: .system)
        button.setup(type)
        return button
    }
    
    func setup(_ type: BDCButtonType) {
        self.type = type
        titleLabel?.font = type.font
        titleLabel?.textColor = type.tintColor
        tintColor = type.tintColor
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: type.height).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let type = self.type
            , !isSetup else {
            return
        }
        
        let layer = type.layer
        layer.frame.size = frame.size
        
        self.layer.insertSublayer(layer, at: 0)
        
        isSetup = true
    }
}
