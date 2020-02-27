//
//  UserItem.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

enum UserItem {
    case merchantName
    case destinationAddress
    case localCurrency
    case pin
}

extension UserItem: Item {
    
    // MARK: - Item
    var title: String {
        switch self {
        case .merchantName:
            return Localized.merchantName
        case .destinationAddress:
            return Localized.destinationAddress
        case .localCurrency:
            return Localized.localCurrency
        case .pin:
            return Localized.pin
        }
    }
    
    var description: String {
        switch self {
        case .merchantName:
            return UserManager.shared.companyName ?? " "
        case .destinationAddress:
            return UserManager.shared.destination ?? " "
        case .localCurrency:
            return "\(UserManager.shared.selectedCurrency.name) \(UserManager.shared.selectedCurrency.currency)"
        case .pin:
            return UserManager.shared.hasPin ? "####" : " "
        }
    }
    
    var image: UIImage {
        switch self {
        case .merchantName:
            return UIImage(imageLiteralResourceName: "setting_company_name")
        case .destinationAddress:
            return UIImage(imageLiteralResourceName: "setting_destination")
        case .localCurrency:
            return UIImage(imageLiteralResourceName: "setting_currency")
        case .pin:
            return UIImage(imageLiteralResourceName: "setting_pin_code")
        }
    }
    
}

private struct Localized {
    static var merchantName: String { NSLocalizedString("settings_merchant_name", comment: "") }
    static var destinationAddress: String { NSLocalizedString("settings_destination_address", comment: "") }
    static var localCurrency: String { NSLocalizedString("settings_local_currency", comment: "") }
    static var pin: String { NSLocalizedString("settings_pin_code", comment: "") }
}
