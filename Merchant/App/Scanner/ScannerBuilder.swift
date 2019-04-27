//
//  ScannerBuilder.swift
//  SLPWalletDemo
//
//  Created by Angel Mortega on 2019/03/20.
//  Contributors Jean-Baptiste Dominguez.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class ScannerBuilder {
    
    func provide(_ scannerDelegate: ScannerDelegate) -> ScannerViewController {
        let viewController = ScannerViewController()
        
        let presenter = ScannerPresenter()
        let router = ScannerRouter(viewController)
        
        presenter.viewDelegate = viewController
        presenter.scannerDelegate = scannerDelegate
        presenter.router = router
        
        viewController.presenter = presenter
        
        return viewController
    }
}
