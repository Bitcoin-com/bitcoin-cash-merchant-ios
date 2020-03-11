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
    
    func logEvent(_ eventName: String, withParameters parameters: [String: Any]?) {
        Amplitude.instance()?.logEvent(eventName, withEventProperties: parameters)
    }
    
}
