//
//  InvoiceRequestOutput.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct InvoiceOutput: Codable {
    
    // MARK: - Properties
    let address: String
    let script: String
    let amount: Double
    
}
