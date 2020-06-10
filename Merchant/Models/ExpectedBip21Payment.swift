//
//  InvoiceRequest.swift
//  Merchant
//
//  Created by pokkst on 5/9/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct ExpectedBip21Payment: Codable {
    // MARK: - Properties
    let address: String
    let amount: Int64
}
