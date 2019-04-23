//
//  BDCTableView.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/11.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCTableView: UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 7
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.05
    
        // Default raw height
        rowHeight = 64
    }
}
