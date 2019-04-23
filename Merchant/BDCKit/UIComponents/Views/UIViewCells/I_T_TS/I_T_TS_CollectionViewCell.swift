//
//  I_T_TS_CollectionViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/13.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class I_T_TS_CollectionViewCell: UICollectionViewCell {
    
    var viewCell: I_T_TS_ViewCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewCell = I_T_TS_ViewCell(frame: frame)
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
