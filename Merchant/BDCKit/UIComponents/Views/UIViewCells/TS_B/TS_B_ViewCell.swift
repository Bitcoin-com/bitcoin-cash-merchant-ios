//
//  TS_B_ViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/11.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class TS_B_ViewCell: BDCViewCell {

    var titleLabel: BDCLabel
    var subtitleLabel: BDCLabel
    var actionButton: BDCButton
    
    override init(frame: CGRect) {
        var constraints = [NSLayoutConstraint]()
        
        // Title
        //
        titleLabel = BDCLabel.build(.title)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        //
        subtitleLabel = BDCLabel.build(.subtitle2)
        
        // Button
        //
        actionButton = BDCButton.build(.type1)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = BDCColor.white.uiColor
        layer.borderWidth = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(actionButton)
        
        actionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let views = ["col1": stackView, "col2": actionButton]
        
        // Activate the contraints on the View
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[col2(32)]", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[col2(80)]-|", metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[col1]-[col2]-16-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col1]-|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
