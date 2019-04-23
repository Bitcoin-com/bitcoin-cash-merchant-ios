//
//  TS_B_CollectionViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/13.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class TS_B_CollectionViewCell: UICollectionViewCell {
    
    var viewCell: TS_B_ViewCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewCell = TS_B_ViewCell(frame: frame)
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        viewCell.layer.cornerRadius = 7
        
        self.viewCell = viewCell
        
        addSubview(viewCell)
        
        viewCell.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
