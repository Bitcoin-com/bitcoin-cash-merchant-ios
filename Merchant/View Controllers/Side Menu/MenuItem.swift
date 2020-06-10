//
//  MenuItem.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

enum MenuItem {
    case transactions
    case settings
    case termsOfUse
    case serviceTerms
    case privacyPolicy
    case about
    
    var description: String {
        switch self {
        case .transactions:
            return Localized.transactions
        case .settings:
            return Localized.settings
        case .termsOfUse:
            return Localized.termsOfUse
        case .serviceTerms:
            return Localized.serviceTerms
        case .privacyPolicy:
            return Localized.privacyPolicy
        case .about:
            return Localized.about
        }
    }
    
    var isBorderHidden: Bool {
        switch self {
        case .settings, .privacyPolicy:
            return false
        default:
            return true
        }
    }
    
    var image: UIImage {
        switch self {
        case .transactions:
            return UIImage(imageLiteralResourceName: "transactions_icon")
        case .settings:
            return UIImage(imageLiteralResourceName: "settings_icon")
        case .termsOfUse, .serviceTerms, .privacyPolicy:
            return UIImage(imageLiteralResourceName: "ic_contract")
        case .about:
            return UIImage(imageLiteralResourceName: "bitcoin")
        }
    }
}


private struct Localized {
    static var transactions: String { NSLocalizedString("menu_transactions", comment: "") }
    static var settings: String { NSLocalizedString("menu_settings", comment: "") }
    static var termsOfUse: String { NSLocalizedString("menu_terms_of_use", comment: "") }
    static var serviceTerms: String { NSLocalizedString("menu_service_terms", comment: "") }
    static var privacyPolicy: String { NSLocalizedString("menu_privacy_policy", comment: "") }
    static var about: String { NSLocalizedString("menu_about", comment: "") }
}
