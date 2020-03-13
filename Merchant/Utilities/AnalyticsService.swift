//
//  AnalyticsService.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/11/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import Amplitude_iOS

final class AnalyticsService {
    
    // MARK: - Properties
    static let shared = AnalyticsService()
    
    // MARK: - Public API
    func initialize() {
        Amplitude.instance().initializeApiKey(AMPLITUDE_API_KEY)
    }
    
    func logEvent(_ event: Event, withParameters parameters: [String: Any]? = nil) {
        Amplitude.instance()?.logEvent(event.rawValue, withEventProperties: parameters)
    }
    
}

enum Event: String {
    case tapCheckout
    case completedPayment
    case responseFromPayBitcoinCom
    case shareInvoice
    case cancelInvoice
    case tapTransactions
    case tapSettings
    case editPin
    case editDestination
    case editName
    case editCurrency
    case tapWalletAd
    case tapLocalAd
    case tapExchangeAd
}
