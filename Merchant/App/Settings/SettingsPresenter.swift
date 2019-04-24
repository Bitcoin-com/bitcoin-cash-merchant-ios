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
    
    var editUserInteractor: EditUserInteractor?
    
    weak var viewDelegate: SettingsViewController?
    var router: SettingsRouter?
    
    init() {
        
    }
    
    func viewDidLoad() {
        let companyName = UserManager.shared.companyName
        viewDelegate?.onGetCompanyName(companyName)
        
        let destination = UserManager.shared.destination
        viewDelegate?.onGetDestination(destination)
        
        let currency = UserManager.shared.selectedCurrency
        viewDelegate?.onGetCurrency(currency.name)
        
        let realm = try! Realm()
        let currencies: [StoreCurrency] = realm
            .objects(StoreCurrency.self)
            .flatMap({ $0 })
        let selectedIndex = currencies.firstIndex(where: { $0.ticker == currency.ticker }) ?? 0
        viewDelegate?.onGetCurrencies(currencies, selectedIndex: selectedIndex)
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
            let destination = UserManager.shared.destination
            viewDelegate?.onGetDestination(destination)
        }
    }
}
