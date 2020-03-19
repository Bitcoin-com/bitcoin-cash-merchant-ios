//
//  InvoiceStatus.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct InvoiceStatus: Codable {
    
    // MARK: - Properties
    let network: String
    let currency: String
    let outputs: [InvoiceStatusOutput]
    let time: String
    let expires: String
    let status: String
    let merchantId: String
    let memo: String
    let fiatSymbol: String
    let fiatRate: Double
    let fiatTotal: Double
    let paymentAsset: String
    let paymentUrl: String
    let paymentId: String
    let webhookUrl: String
    let txId: String?
    let merchandId: String?
    
    // MARK: - Computed Properties
    var isPaid: Bool {
        return status == "paid"
    }
    var isOpen: Bool {
        return status == "open"
    }
    var isExpired: Bool {
        return status == "expired"
    }
    var totalAmount: Double {
        var total = 0.0
        
        outputs.forEach {
            total += $0.amount
        }
        
        return total
    }
    var firstAddress: String? {
        return outputs.first?.address
    }
    var isInitialized: Bool {
        return paymentUrl.count > 0 && paymentId.count > 0 && fiatTotal != 0.0 && outputs.count > 0
    }
    var isTimerExpired: Bool {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withDashSeparatorInDate, .withFractionalSeconds]
        
        let expiresDate = dateFormatter.date(from: expires)!
        
        return expiresDate < Date()
    }
    
}
