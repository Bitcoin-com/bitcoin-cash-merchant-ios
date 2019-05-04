//
//  SettingsRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class SettingsRouter: BDCRouter {
    
    func transitBackTo() {
        viewController?.dismiss(animated: true)
    }
    
    func transitScan(_ scannerDelegate: ScannerDelegate) {
        let scannerViewController = ScannerBuilder().provide(scannerDelegate)
        let navViewController = UINavigationController(rootViewController: scannerViewController)
        viewController?.present(navViewController, animated: true, completion: nil)
    }

    func transitPinChange(_ pinCheckDelegate : PinCheckDelegate) {
        let vc = PinBuilder().provide(PinMode.Change, pinCheckDelegate)
        let nvc = UINavigationController(rootViewController: vc)
        viewController?.present(nvc, animated: true, completion: nil)
    }
}
