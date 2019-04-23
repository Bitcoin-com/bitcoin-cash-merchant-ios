//
//  BDCCollectionView.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/14.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCCollectionView: UICollectionView {
    
    var padding: CGFloat = 8
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupPadding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPadding()
    }
    
    func setupPadding(_ padding: CGFloat? = nil) {
        if let padding = padding {
            self.padding = padding
        }
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
        }
    }
}
