//
//  SettingsPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsPresenter {
    
    var getCurrenciesInteractor: GetCurrenciesInteractor?
    var editUserInteractor: EditUserInteractor?
    
    weak var viewDelegate: SettingsViewProtocol?
    var router: SettingsRouter?
    
    fileprivate var selectedCurrency: StoreCurrency?
    fileprivate var companyName: String?
    fileprivate var destination: String?

    init() {
        
    }
    
    func viewDidLoad() {
        let companyName = UserManager.shared.companyName ?? ""
        viewDelegate?.onGetCompanyName(companyName)
        
        let destination = UserManager.shared.destination ?? ""
        viewDelegate?.onGetDestination(destination)
        
        let currency = UserManager.shared.selectedCurrency
        viewDelegate?.onGetCurrency(currency.name)
        
        guard let currencies = getCurrenciesInteractor?.getCurrencies() else {
            return
        }
        
        let selectedIndex = currencies.firstIndex(where: { $0.ticker == currency.ticker }) ?? 0
        viewDelegate?.onGetCurrencies(currencies, selectedIndex: selectedIndex)
    }
    
    func didPushSave() {
        if let currency = selectedCurrency {
            editUserInteractor?.editSelectedCurrency(currency)
        }

        if let name = companyName {
            editUserInteractor?.editCompanyName(name)
        }
        
        if let destination = destination {
            let _ = editUserInteractor?.editDestination(destination)
        }
    }
    
    func didPushScan() {
        router?.transitScan(self)
    }

    func didPushChangePin() {
        let pinMode: PinMode = UserManager.shared.hasPin() ? .change : .set
        router?.transitToPin(pinMode)
    }
    
    func didPushClose() {
        router?.transitBackTo()
    }
    
    func didEditSelectedCurrency(_ newCurrency: StoreCurrency) {
        selectedCurrency = newCurrency
        viewDelegate?.onGetCurrency(newCurrency.name)
    }
    
    func didEditCompanyName(_ newCompanyName: String) {
        companyName = newCompanyName
    }
    
    func didEditDestination(_ newDestination: String) {
        destination = newDestination
        viewDelegate?.onGetDestination(newDestination)
    }
}

extension SettingsPresenter: ScannerDelegate {
    func onScanResult(value: String?) {
        guard let value = value else {
            return
        }
        
        viewDelegate?.onGetDestination(value)
        
        didEditDestination(value)
    }
}
