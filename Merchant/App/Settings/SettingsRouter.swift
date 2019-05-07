//
//  SettingsRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

class SettingsRouter: BDCRouter {
    
    func transitBackTo() {
        viewController?.dismiss(animated: true)
    }
    
    func transitScan(_ scannerDelegate: ScannerDelegate) {
        let scannerViewController = ScannerBuilder().provide(scannerDelegate)
        viewController?.navigationController?.pushViewController(scannerViewController, animated: true)
    }
    
    func transitToPin(_ pinMode: PinMode) {
        let pinViewController = PinBuilder().provide(pinMode)
        viewController?.navigationController?.pushViewController(pinViewController, animated: true)
    }
}
