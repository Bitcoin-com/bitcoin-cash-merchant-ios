//
//  CardView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/23/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .clear
        
        addStandardCornedRadiusAndShadow()
    }
    
}
