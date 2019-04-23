//
//  SettingsViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var companyNameLabel: BDCLabel! { didSet { companyNameLabel.setup(.title) } }
    @IBOutlet weak var companyNameTextField: BDCTextField! { didSet { companyNameTextField.setup(.type1) } }
    
    
    @IBOutlet weak var destinationAddressLabel: BDCLabel! { didSet { destinationAddressLabel.setup(.title) } }
    @IBOutlet weak var destinationAddressTextField: BDCTextField! { didSet { destinationAddressTextField.setup(.type1) } }
    
    
    @IBOutlet weak var localCurrencyLabel: BDCLabel! { didSet { localCurrencyLabel.setup(.title) } }
    @IBOutlet weak var localCurrencyValueLabel: BDCLabel! { didSet { localCurrencyValueLabel.setup(.subtitle) } }
    
    
    
    var presenter: SettingsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        companyNameTextField.delegate = self
        destinationAddressTextField.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        
        presenter?.viewDidLoad()
    }
    
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
    
    func onGetCompanyName(_ companyName: String) {
        companyNameTextField.text = companyName
    }
    
    func onGetDestination(_ destination: String) {
        destinationAddressTextField.text = destination
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == companyNameTextField {
            
            guard let newCompanyName = companyNameTextField.text else {
                return
            }
            
            presenter?.didEditCompanyName(newCompanyName)
        } else if textField == destinationAddressTextField {
            
            guard let newDestination = destinationAddressTextField.text else {
                return
            }
            
            presenter?.didEditDestination(newDestination)
        }
    }
}

extension SettingsViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -130 {
            presenter?.didPushClose()
        }
    }
}
