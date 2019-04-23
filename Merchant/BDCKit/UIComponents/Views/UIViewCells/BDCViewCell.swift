//
//  BDCViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/13.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCViewCell: BDCView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 7
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.05
    }
}
