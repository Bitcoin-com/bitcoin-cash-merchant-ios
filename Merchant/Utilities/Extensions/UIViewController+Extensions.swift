//
//  UIViewController+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SafariServices

extension UIViewController {
    
    var isConnectedToNetwork: Bool {
        return NetworkManager.shared.isConnected
    }
    
    func showAlert(withTitle title: String? = nil, message: String, cancelActionTitle: String? = nil, confirmationActionTitle : String? = nil, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelActionTitle = cancelActionTitle {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .default)
            alertController.addAction(cancelAction)
        }
        if let confirmationActionTitle = confirmationActionTitle, let confirmationActionHandler = actionHandler {
            let confirmationAction = UIAlertAction(title: confirmationActionTitle, style: .default, handler: confirmationActionHandler)
            alertController.addAction(confirmationAction)
        }
        
        present(alertController, animated: true)
    }
    
    func showErrorAlert(_ error: String) {
        showAlert(withTitle: Localized.error, message: error, cancelActionTitle: Localized.ok, confirmationActionTitle: nil, actionHandler: nil)
    }
    
    func openLinkInSafari(link: String) {
        guard let url = URL(string: link) else { return }

        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedSchemeLink = "https://\(link)"

            if let url = URL(string: appendedSchemeLink) {
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.modalPresentationStyle = .fullScreen
                present(safariViewController, animated: true)
            }
        } else {
            if let url = URL(string: link) {
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.modalPresentationStyle = .fullScreen
                present(safariViewController, animated: true)
            }
        }
    }
    
}

private struct Localized {
    static var error: String { NSLocalizedString("error", comment: "") }
    static var ok: String { NSLocalizedString("prompt_ok", comment: "") }
}
