//
//  ITCollectionViewCell.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/09.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class ITCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = 56/2
            iconImageView.layer.borderWidth = 0
        }
    }
    @IBOutlet weak var titleLabel: BDCLabel! { didSet { titleLabel.setup(.subtitle3) } }
        
}
