//
//  CountryCurrency.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/24/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

final class CountryCurrency: Codable {
    
    // MARK: - Properties
    let iso: String
    let currency: String
    let language: String
    let name: String
    let decimals: Int
    var locale: Locale {
        if language.contains("-") {
            return Locale(identifier: "\(language.replacingOccurrences(of: "-", with: "_"))")
        }
        
        return Locale(identifier: "\(language)_\(iso)")
    }
    
    enum CodingKeys: String, CodingKey {
        case iso
        case currency
        case language = "lang"
        case name
        case decimals
    }
    
}

extension CountryCurrency: Equatable {
    
    // MARK: - Equatable
    static func ==(lhs: CountryCurrency, rhs: CountryCurrency) -> Bool {
        return lhs.name == rhs.name && lhs.iso == rhs.iso && lhs.currency == rhs.currency
    }
    
}

extension CountryCurrency: Item {
    
    // MARK: - Item
    var title: String {
        return name
    }
    
    var description: String {
        return currency
    }
    
    var image: UIImage {
        return UIImage(imageLiteralResourceName: "iso_\(iso.lowercased())")
    }
    
}
