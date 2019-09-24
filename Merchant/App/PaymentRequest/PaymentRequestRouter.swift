//
//  PaymentRequestRouter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import BDCKit

class PaymentRequestRouter: BDCRouter {
    
    func transitBackTo() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func openPopup(receivedAmount: Int64, expectedAmount: Int64) {
        let pvc = AmountMismatchedBuilder().provide(expectedAmount: expectedAmount, receivedAmount: receivedAmount)
        pvc.modalPresentationStyle = .popover
        pvc.preferredContentSize = CGSize(width: 374, height: 350)
        pvc.actionButtonHandler = {
            pvc.dismiss(animated: true, completion: nil)
        }
        
        let popover: UIPopoverPresentationController = pvc.popoverPresentationController!
        popover.delegate = viewController as? UIPopoverPresentationControllerDelegate
        popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popover.sourceRect = UIScreen.main.center
        popover.sourceView = viewController?.view
        
        viewController?.present(pvc, animated: true, completion: nil)
    }
}
