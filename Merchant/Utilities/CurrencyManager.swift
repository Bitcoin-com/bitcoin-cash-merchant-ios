//
//  CurrencyManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/24/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

final class CurrencyManager {
    
    // MARK: - Properties
    static let shared = CurrencyManager()
    var countryCurrencies = [CountryCurrency]()
    
    // MARK: - Initializer
    private init() {
        fetchCurrencies()
    }
    
    // MARK: - Public API
    func defaultCurrency() -> CountryCurrency {
        return countryCurrencies.filter({ $0.language == AppConstants.DEFAULT_LOCALE }).first!
    }
    
    func currencyFromLocale() -> CountryCurrency? {
        let identifier = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        
        if let first = countryCurrencies.filter({ $0.language == identifier }).first {
            return first
        }
        
        return nil
    }
    
    // MARK: - Private API
    private func fetchCurrencies() {
        guard let path = Bundle.main.path(forResource: "CountryCurrency", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            
            countryCurrencies = try decoder.decode([CountryCurrency].self, from: data)
            
            Logger.log(message: "Parsing successful", type:  .success)
        } catch {
            Logger.log(message: "Parsing error: \(error.localizedDescription)", type:  .error)
            Logger.log(message: "Parsing error: \(error)", type:  .error)
        }
    }
    
}
