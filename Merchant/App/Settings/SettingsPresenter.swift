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
    
    weak var viewDelegate: SettingsViewController?
    var router: SettingsRouter?
    
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
        editUserInteractor?.editSelectedCurrency(newCurrency)
        viewDelegate?.onGetCurrency(newCurrency.name)
    }
    
    func didEditCompanyName(_ newCompanyName: String) {
        editUserInteractor?.editCompanyName(newCompanyName)
    }
    
    func didEditDestination(_ newDestination: String) {
        
        guard let editUserInteractor = self.editUserInteractor else {
            return
        }
        
        if !editUserInteractor.editDestination(newDestination) {
            let destination: String = UserManager.shared.destination ?? ""
            viewDelegate?.onGetDestination(destination)
        }
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
