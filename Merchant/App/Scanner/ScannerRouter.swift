//
//  ScannerRouter.swift
//  SLPWalletDemo
//
//  Created by Angel Mortega on 2019/03/20.
//  Contributors Jean-Baptiste Dominguez.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

class ScannerRouter: BDCRouter {
    
    func transitBack() {
        viewController?.dismiss(animated: true)
    }
}
