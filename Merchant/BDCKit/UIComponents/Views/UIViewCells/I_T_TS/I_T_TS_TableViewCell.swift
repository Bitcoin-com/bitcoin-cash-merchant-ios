//
//  I_T_TS_TableViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/09.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class I_T_TS_TableViewCell: BDCTableViewCell {
    
    var viewCell: I_T_TS_ViewCell?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let viewCell = I_T_TS_ViewCell(frame: frame)
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewCell = viewCell
        
        addSubview(viewCell)
        
        viewCell.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}
