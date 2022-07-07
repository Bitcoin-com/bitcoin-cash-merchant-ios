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
    func syncXPub(with address: String) {
        guard let data = address.data(using: .utf8) else { return }
        
        let key = PublicKey(bytes: data, network: .mainnetBCH)
        let address = key.toBitcoinAddress()
        
        doesAddressHaveHistoryOnBlockchain(address.cashaddr)
    }
    
    func generateAddressFromStoredIndex() -> String? {
        return generateNewAddress()
    }

    // MARK: - Private API
    
    // FIXME: This functionality currently requests information from a deprecated API, but fails silently.
    private func doesAddressHaveHistoryOnBlockchain(_ address: String) {
        guard let data = address.data(using: .utf8) else { return }

        let key = PublicKey(bytes: data, network: .mainnetBCH)
        let address = key.toBitcoinAddress()

        if let url = URL(string: "\(Endpoints.addressDetails)/\(address.cashaddr)") {
            do {
                let data = try Data(contentsOf: url)

                do {
                    let addressDetails = try JSONDecoder().decode(AddressDetails.self, from: data)
                    Logger.log(message: "Transactions: \(addressDetails.transactions.count)", type: .debug)

                    if addressDetails.transactions.count > 0,
                        let address = generateNewAddress(shouldIncrementIndex: true) {
                        doesAddressHaveHistoryOnBlockchain(address)
                    }
                } catch {
                    Logger.log(message: "Unable to parse: \(error.localizedDescription) | \(error)", type: .error)
                    AnalyticsService.shared.logEvent(.error_syncing_xpub, withError: error)
                }
            } catch {
                AnalyticsService.shared.logEvent(.error_rest_bitcoin_com_scan_address_funds, withError: error)
            }
        }
    }
    
    private func generateNewAddress(shouldIncrementIndex: Bool = false) -> String? {
        guard let paymentTarget = UserManager.shared.activePaymentTarget else { return nil }
        let xpub = paymentTarget.legacyAddress
        let index = UserManager.shared.xPubKeyIndex
        let indices = 0..<UInt32(index + 1)
        
        do {
            Logger.log(message: "Generating Bitcoin Address for xPubKey index: \(index)", type: .info)
            
            let publicKeys = try ReadOnlyHDWallet.publicKeys(extendedPublicKey: xpub, indices: indices, chain: .external)
            guard let publicKey = publicKeys.last else {
                Logger.log(message: "Unable to retrieve newest public key for xPubKey index: \(index)", type: .info)
                return nil
            }
            
            if shouldIncrementIndex {
                UserManager.shared.xPubKeyIndex += 1
            }
        
            return publicKey.toBitcoinAddress().cashaddr
        }
        catch {
            Logger.log(message: "Unable to generate Bitcoin Address for xPubKey index \(index): \(error.localizedDescription) | \(error)", type: .error)
            AnalyticsService.shared.logEvent(.error_generate_address_from_xpub, withError: error)
            return nil
        }
    }
}
