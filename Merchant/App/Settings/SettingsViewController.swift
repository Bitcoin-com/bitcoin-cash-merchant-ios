//
//  SettingsViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie
import BDCKit

class SettingsViewController: BDCViewController {
    
    fileprivate let cellId = "settingsCell"
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    var companyNameTextField = BDCTextField.build(.type1)
    var destinationAddressTextField = BDCTextField.build(.type1)
    var pinCodeLabel = BDCLabel.build(.subtitle)
    var selectedCurrencyLabel = BDCLabel.build(.subtitle)
    var currenciesPickerView = UIPickerView(frame: .zero)
    var currenciesView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var presenter: SettingsPresenter?
    var currencyItems = [StoreCurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.Strings.settings
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.fillSuperView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        
        // Currency Picker
        currenciesPickerView.dataSource = self
        currenciesPickerView.delegate = self
        
        let closeButton = BDCButton.build(.type3)
        closeButton.setImage(UIImage(named: "close_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = BDCColor.green.uiColor
        closeButton.addTarget(self, action: #selector(didPushCloseSelectCurrency), for: .touchUpInside)
        
        let currenciesStackView = UIStackView(arrangedSubviews: [currenciesPickerView, closeButton])
        currenciesStackView.translatesAutoresizingMaskIntoConstraints = false
        currenciesStackView.axis = .vertical
        currenciesStackView.distribution = .fill
        currenciesStackView.alignment = .fill
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.effect = UIBlurEffect(style: .light)
        blurView.alpha = 1
        
        currenciesView.addSubview(blurView)
        blurView.fillSuperView()
        
        currenciesView.addSubview(currenciesStackView)
        currenciesStackView.topAnchor.constraint(equalTo: currenciesView.topAnchor, constant: 32).isActive = true
        currenciesStackView.bottomAnchor.constraint(equalTo: currenciesView.bottomAnchor, constant: -32).isActive = true
        currenciesStackView.leadingAnchor.constraint(equalTo: currenciesView.leadingAnchor, constant: 0).isActive = true
        currenciesStackView.trailingAnchor.constraint(equalTo: currenciesView.trailingAnchor, constant: 0).isActive = true
        
        hideKeyboardWhenTappedAround()
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func didPushClose() {
        dismissKeyboard()
        presenter?.didPushClose()
    }
    
    func onGetCompanyName(_ companyName: String) {
        companyNameTextField.text = companyName
    }
    
    func onGetDestination(_ destination: String) {
        destinationAddressTextField.text = destination
    }
    
    func onGetCurrency(_ currency: String) {
        selectedCurrencyLabel.text = currency
    }
    
    func onGetCurrencies(_ currencies: [StoreCurrency], selectedIndex: Int) {
        currencyItems = currencies
        currenciesPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsEntry.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.selectionStyle = .none
        cell.subviews.forEach({ $0.removeFromSuperview() })
        
        let item = SettingsEntry.allCases[indexPath.item]
        
        let titleLabel = BDCLabel.build(.title)
        titleLabel.text = item.title
        titleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let headerStackView = UIStackView(arrangedSubviews: [titleLabel])
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fill
        headerStackView.alignment = .fill
        headerStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [headerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        switch item {
        case .address:
            destinationAddressTextField.placeholder = item.placeholder
            destinationAddressTextField.returnKeyType = .done
            destinationAddressTextField.delegate = self
            stackView.addArrangedSubview(destinationAddressTextField)
            
            let iconButton = BDCButton.build(.type1)
            iconButton.setTitle(Constants.Strings.scan, for: .normal)
            iconButton.translatesAutoresizingMaskIntoConstraints = false
            iconButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            iconButton.addTarget(self, action: #selector(didPushScan), for: .touchUpInside)
            
            headerStackView.addArrangedSubview(iconButton)
 
        case .companyName:
            companyNameTextField.placeholder = item.placeholder
            companyNameTextField.returnKeyType = .done
            companyNameTextField.delegate = self
            stackView.addArrangedSubview(companyNameTextField)
            
        case .pinCode:
            pinCodeLabel.text = item.placeholder
            stackView.addArrangedSubview(pinCodeLabel)
            
            let iconButton = BDCButton.build(.type1)
            iconButton.setTitle(Constants.Strings.change, for: .normal)
            iconButton.translatesAutoresizingMaskIntoConstraints = false
            iconButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            iconButton.addTarget(self, action: #selector(didPushChangePin), for: .touchUpInside)
            
            headerStackView.addArrangedSubview(iconButton)
            
        case .selectedCurrency:
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPushSelectCurrency)))
            stackView.addArrangedSubview(selectedCurrencyLabel)
        }
        
        cell.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16).isActive = true
        
        return cell
    }
    
    @objc func didPushSelectCurrency() {
        dismissKeyboard()
        
        currenciesView.alpha = 0
        view.addSubview(currenciesView)
        currenciesView.fillSuperView()
        
        UIView.animate(withDuration: 0.2) {
            self.currenciesView.alpha = 1
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    @objc func didPushScan() {
        presenter?.didPushScan()
    }
    
    @objc func didPushChangePin() {
        presenter?.didPushChangePin()
    }
    
    @objc func didPushCloseSelectCurrency() {
        currenciesView.removeFromSuperview()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -130 {
            dismissKeyboard()
            presenter?.didPushClose()
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

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

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(currencyItems[row].name) (\(currencyItems[row].symbol))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter?.didEditSelectedCurrency(currencyItems[row])
    }
}
