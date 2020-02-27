//
//  InvoiceStatusOutput.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct InvoiceStatusOutput: Codable {
    
    // MARK: - Properties
    let address: String
    let script: String
    let type: String
    let amount: Double
    
}
