//
//  WalletManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/7/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import BitcoinKit

final class WalletManager {

    // MARK: - Properties
    static let shared = WalletManager()
    
    // MARK: - Public API
    func getAddressFromXPubKey() -> String? {
        guard let paymentTarget = UserManager.shared.activePaymentTarget else { return nil }
        
        getAddressDetails(paymentTarget.address)
        
        return nil
    }
    
    // MARK: - Private API
    private func getAddressDetails(_ address: String) {
        let cleanAddress = address.replacingOccurrences(of: "bitcoincash:", with: "")
        
        RESTManager.shared.GET(from: "\(Endpoints.addressDetails)/\(cleanAddress)") { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let addressDetails = try JSONDecoder().decode(AddressDetails.self, from: data)
                    Logger.log(message: "Transactions: \(addressDetails.transactions.count)", type: .debug)
                } catch {
                    Logger.log(message: "Unable to parse: \(error.localizedDescription) | \(error)", type: .error)
                }
            case .failure(let error):
                Logger.log(message: "Error fetching address details: \(error.localizedDescription)", type: .error)
            }
        }
    }

}
