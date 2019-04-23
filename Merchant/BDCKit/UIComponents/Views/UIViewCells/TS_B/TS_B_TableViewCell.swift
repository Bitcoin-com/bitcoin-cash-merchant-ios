//
//  TS_B_TableViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/13.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class TS_B_TableViewCell: BDCTableViewCell {
    
    var viewCell: TS_B_ViewCell?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let viewCell = TS_B_ViewCell(frame: frame)
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewCell = viewCell
        
        addSubview(viewCell)
        
        viewCell.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
