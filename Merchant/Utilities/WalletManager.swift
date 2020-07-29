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
    
}
