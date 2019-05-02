//
//  PinPresenter.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol PinCheckDelegate {
    func onPinChecked()
}

class PinPresenter {
    var router: PinRouter?
    weak var viewDelegate: PinController?
    var pinCheckDelegate: PinCheckDelegate?

    var selectedPin: String? = ""
    
    init() {
        selectedPin = UserManager.shared.pin;
    }
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
    }
}

extension PinPresenter {
    func didPushClose() {
        router?.transitBack()
    }
}
