//
//  SettingsViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie

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
    var selectedCurrencyLabel = BDCLabel.build(.subtitle)
    var currenciesPickerView = UIPickerView(frame: .zero)
    var currenciesStackView = UIStackView(arrangedSubviews: [])

    var presenter: SettingsPresenter?
    var currencyItems = [StoreCurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
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
        
        currenciesStackView.addArrangedSubview(currenciesPickerView)
        currenciesStackView.addArrangedSubview(closeButton)
        currenciesStackView.translatesAutoresizingMaskIntoConstraints = false
        currenciesStackView.axis = .vertical
        
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
        
        let item = SettingsEntry.allCases[indexPath.item]
        
        let titleLabel = BDCLabel.build(.title)
        titleLabel.text = item.title
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        switch item {
        case .address:
            destinationAddressTextField.placeholder = item.placeholder
            destinationAddressTextField.delegate = self
            stackView.addArrangedSubview(destinationAddressTextField)
         case .companyName:
            companyNameTextField.placeholder = item.placeholder
            companyNameTextField.delegate = self
            stackView.addArrangedSubview(companyNameTextField)
        case .selectedCurrency:
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPushSelectCurrency)))
            stackView.addArrangedSubview(selectedCurrencyLabel)
        }
        
        cell.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 16).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        return cell
    }
    
    @objc func didPushCloseSelectCurrency() {
        currenciesStackView.removeFromSuperview()
    }
    
    @objc func didPushSelectCurrency() {
        view.addSubview(currenciesStackView)
        currenciesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currenciesStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currenciesStackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -130 {
            presenter?.didPushClose()
        }
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
