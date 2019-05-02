//
//  PinRouter.swift
//  Merchant
//
//  Created by Xavier Kral on 5/1/19.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

class PinRouter: BDCRouter {
    func transitBack() {
        viewController?.dismiss(animated: true)
    }
}
