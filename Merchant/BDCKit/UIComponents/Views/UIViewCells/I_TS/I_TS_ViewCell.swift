//
//  I_TS_ViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class I_TS_ViewCell: BDCViewCell {
    
    var iconImageView: UIImageView
    var titleLabel: BDCLabel
    var subtitleLabel: BDCLabel
    
    override init(frame: CGRect) {
        var constraints = [NSLayoutConstraint]()
        
        // Icon
        //
        iconImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // View for the Icon
        //
        let iconView = UIView(frame: CGRect.zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(iconImageView)
        
        // Setup constraints for Icon
        iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        
        // Title
        //
        titleLabel = BDCLabel.build(.title)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle
        //
        subtitleLabel = BDCLabel.build(.subtitle)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Super init
        super.init(frame: frame)
        
        backgroundColor = BDCColor.white.uiColor
        layer.borderWidth = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(stackView)
        
        let views = ["icon": iconImageView, "col1": iconView, "col2": stackView]
        
        // Define the contraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[icon(24)]|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[icon(24)]", metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[col1]-[col2]-16-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col1]-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col2]-|", metrics: nil, views: views)
        
        // Activate the contraints
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
