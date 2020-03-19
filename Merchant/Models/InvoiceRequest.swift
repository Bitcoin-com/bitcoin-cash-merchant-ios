//
//  InvoiceRequest.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct InvoiceRequest: Codable {
    
    // MARK: - Properties
    let memo = UUID().uuidString
    let webhook = "http://127.0.0.1/unused/webhook"
    let fiatAmount: Double
    let fiat: String
    let apiKey: String?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case memo
        case webhook
        case fiatAmount
        case fiat
        case apiKey
        case address
    }
    
}
