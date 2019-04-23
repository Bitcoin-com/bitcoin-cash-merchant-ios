//
//  BDCClearNavViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/16.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class BDCClearNavViewController: BDCViewController {
    
    var shadowImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        // Handles the shadow image
        shadowImage = navigationController?.navigationBar.shadowImage
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}


extension BDCClearNavViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0) {
            navigationController?.navigationBar.shadowImage = shadowImage
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}
