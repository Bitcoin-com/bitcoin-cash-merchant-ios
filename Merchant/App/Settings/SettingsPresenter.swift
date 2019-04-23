//
//  SettingsPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class SettingsPresenter {
    
    var editUserInteractor: EditUserInteractor?
    
    weak var viewDelegate: SettingsViewController?
    var router: SettingsRouter?
    
    func viewDidLoad() {
        let companyName = UserManager.shared.companyName
        viewDelegate?.onGetCompanyName(companyName ?? "")
        
        let destination = UserManager.shared.destination
        viewDelegate?.onGetDestination(destination ?? "")
    }
    
    func didPushClose() {
        router?.transitBackTo()
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
            viewDelegate?.onGetDestination(destination ?? "")
        }
    }
}
