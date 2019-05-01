//
//  UIView+Extensions.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/14.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperView() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        guard let superView = superview else {
            return
        }
        
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
                bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        } else {
            topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        }
    }
}
