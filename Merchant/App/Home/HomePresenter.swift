//
//  HomePresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter {
    
    var router: HomeRouter?
    weak var viewDelegate: HomeViewController?
    
    var companyName: String
    
    init() {
        companyName = UserManager.shared.companyName
    }
    
    func viewDidLoad() {
        setupCompanyName()
    }
    
    func viewDidAppear() {
        setupCompanyName()
    }
    
    func didPushSettings() {
        router?.transitToSettings()
    }
}

// Private methods
extension HomePresenter {
    
    func setupCompanyName() {
        let newCompanyName = UserManager.shared.companyName
        companyName = newCompanyName
        viewDelegate?.onCompanyName(companyName)
    }
}
