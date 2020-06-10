//
//  Endpoints.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

let BASE_URL = "https://pay.bitcoin.com"

struct Endpoints {
	static let createInvoice = "\(BASE_URL)/create_invoice"
    static let qr = "\(BASE_URL)/qr"
    static let bitcoin = "https://www.bitcoin.com"
    static let termsOfUse = "https://www.bitcoin.com/legal/"
    static let serviceTerms = "https://www.bitcoin.com/bitcoin-cash-register/service-terms/"
    static let privacyPolicy = "https://www.bitcoin.com/privacy-policy/"
    static let localBitcoin = "https://local.bitcoin.com"
    static let exchangeBitcoin = "https://exchange.bitcoin.com"
    static let restBitcoin = "https://rest.bitcoin.com/v2"
    static let explorerBitcoin = "https://explorer.bitcoin.com/bch"
    static let websocket = "wss://pay.bitcoin.com/s"
    static let bip21Websocket = "wss://bch.api.wallet.bitcoin.com/bws/api/socket/v1/address"
    static let wallet = "bitcoincash:?r="
    static let addressDetails = "\(Endpoints.restBitcoin)/address/details"
    static let bitcoinWalletAppStore = "https://apps.apple.com/us/app/bitcoin-wallet-by-bitcoin-com/id1252903728"
}
