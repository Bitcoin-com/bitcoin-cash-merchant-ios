//
//  BDCNavViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/09.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupBDCNav() {
        let logo = UIImage(named: "logo_header_black")
        let imageView = UIImageView(image: logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleView = UIView()
        titleView.addSubview(imageView)
        
        imageView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        navigationItem.titleView = titleView
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
