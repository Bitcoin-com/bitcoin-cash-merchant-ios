//
//  SettingsEntity.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/25.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

enum SettingsEntry: CaseIterable {
    case companyName
    case address
    case selectedCurrency
}

extension SettingsEntry {
    var title: String {
        switch self {
        case .companyName:
            return "Company name"
        case .address:
            return "Address"
        case .selectedCurrency:
            return "Local currency"
        }
    }
    
    var placeholder: String {
        switch self {
        case .companyName:
            return "Enter a company name"
        case .address:
            return "Enter a destination address"
        default:
            return ""
        }
    }
}
