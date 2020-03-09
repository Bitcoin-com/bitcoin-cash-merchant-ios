//
//  AddressDetails.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/7/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

final class AddressDetails: Codable {
    
    // MARK: - Properties
    let balance: Double
    let balanceSat: Double
    let totalReceived: Double
    let totalReceivedSat: Double
    let totalSent: Double
    let totalSentSat: Double
    let unconfirmedBalance: Double
    let unconfirmedBalanceSat: Double
    let unconfirmedTxApperances: Int
    let txApperances: Int
    let transactions: [String]
    let legacyAddress: String
    let cashAddress: String
    let slpAddress: String
    let currentPage: Int
    let pagesTotal: Int
    
}
