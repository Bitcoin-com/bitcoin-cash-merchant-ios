//
//  PaymentInputRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/18.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentInputRouter: BDCRouter {
    
    func transitToPaymentDetail(_ pr: PaymentRequest, requestDelegate: PaymentRequestPresenterDelegate) {
        let paymentRequestViewController = PaymentRequestBuilder().provide(pr, requestDelegate: requestDelegate)
        let navViewController = UINavigationController(rootViewController: paymentRequestViewController)
        navViewController.modalPresentationStyle = .custom
        navViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
        navViewController.modalPresentationCapturesStatusBarAppearance = false
        viewController?.present(navViewController, animated: true, completion: nil)
    }
    
    func transitToSettings() {
        SecureAccessService.transitTo({ [weak self] in
            let settingsViewController = SettingsBuilder().provide()
            let navViewController = UINavigationController(rootViewController: settingsViewController)
            self?.viewController?.present(navViewController, animated: true, completion: nil)
        })
    }
}
