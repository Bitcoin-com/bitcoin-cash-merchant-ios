//
//  IT_T_TS_ViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/13.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class I_T_TS_ViewCell: BDCViewCell {
    
    var iconImageView: UIImageView
    var title1Label: BDCLabel
    var title2Label: BDCLabel
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
        
        // Title 1
        //
        title1Label = BDCLabel.build(.title)
        title1Label.translatesAutoresizingMaskIntoConstraints = false
        
        // Title 2
        //
        title2Label = BDCLabel.build(.title)
        
        // Subtitle
        //
        subtitleLabel = BDCLabel.build(.subtitle)
        
        let stackView = UIStackView(arrangedSubviews: [title2Label, subtitleLabel])
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
        addSubview(title1Label)
        addSubview(stackView)
        
        let views = ["icon": iconImageView, "col1": iconView, "col2": title1Label, "col3": stackView]
        
        // Define the contraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[icon(24)]|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[icon(24)]", metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[col1]-16-[col2]-[col3]-16-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col1]-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col2]-|", metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[col3]-|", metrics: nil, views: views)
        
        // Activate the contraints
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
