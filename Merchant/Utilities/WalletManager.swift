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
    private var wallet: HDWallet?
    private var index = 0 {
        didSet {
            UserManager.shared.xPubKeyIndex = index
        }
    }
    
    // MARK: - Public API
    func syncXPub(with address: String) {
        guard let data = address.data(using: .utf8) else { return }
        
        wallet = HDWallet(seed: data, externalIndex: 0, internalIndex: 0, network: .mainnetBCH)
        
        let key = PublicKey(bytes: data, network: .mainnetBCH)
        let address = key.toBitcoinAddress()
        
        doesAddressHaveHistoryOnBlockchain(address.cashaddr)
    }
    
    // MARK: - Public API
    func generateAddressFromStoredIndex() -> String? {
        guard let paymentTarget = UserManager.shared.activePaymentTarget else { return nil }
        guard let data = paymentTarget.address.data(using: .utf8) else { return nil }
        
        wallet = HDWallet(seed: data, externalIndex: 0, internalIndex: 0, network: .mainnetBCH)
        
        let index = UInt32(UserManager.shared.xPubKeyIndex)
        
        Logger.log(message: "Generating Bitcoin Address for xPubKey index: \(UserManager.shared.xPubKeyIndex)", type: .info)
        
        if index > 0 {
            wallet?.incrementExternalIndex(by: index)
            
            return wallet?.address.cashaddr
        }
        
        return wallet?.address.cashaddr
    }

    // MARK: - Private API
    private func doesAddressHaveHistoryOnBlockchain(_ address: String) {
        guard let data = address.data(using: .utf8) else { return }
            
        let key = PublicKey(bytes: data, network: .mainnetBCH)
        let address = key.toBitcoinAddress()
        
        if let url =  URL(string: "\(Endpoints.addressDetails)/\(address.cashaddr)") {
            if let data = try? Data(contentsOf: url) {
                do {
                    let addressDetails = try JSONDecoder().decode(AddressDetails.self, from: data)
                    Logger.log(message: "Transactions: \(addressDetails.transactions.count)", type: .debug)
                    
                    if addressDetails.transactions.count > 0 {
                        if let address = generateNewAddress() {
                            doesAddressHaveHistoryOnBlockchain(address)
                        }
                    } else {
                        UserManager.shared.xPubKeyIndex = index
                    }
                } catch {
                    Logger.log(message: "Unable to parse: \(error.localizedDescription) | \(error)", type: .error)
                    AnalyticsService.shared.logEvent(.error_syncing_xpub, withError: error)
                }
            }
        }
    }
    
    private func generateNewAddress() -> String? {
        index += 1
        wallet?.incrementExternalIndex(by: 1)
        
        return wallet?.address.cashaddr
    }
    
}
