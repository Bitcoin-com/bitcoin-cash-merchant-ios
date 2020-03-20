//
//  Tests.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

struct Tests {
    
    struct NavigationBar {
        static let identifier = "tests--navigationBarIdentifier"
        static let closeButton = "tests--closeButton"
    }
    
    struct ItemsView {
        static let tableView = "tests--tableView"
    }
    
    struct Transactions {
        static let tableView = "tests--transactionsTableView"
        static let noHistoryImageView = "tests--noHistoryImageView"
        static let noHistoryLabel = "tests--noHistoryLabel"
    }
    
    struct SideMenu {
        static let tableView = "tests--sideMenuTableView"
    }
    
    struct Currencies {
        static let itemsView = "tests--currenciesItemsView"
    }
    
    struct Pin {
        static let explanationLabel = "tests--explanationLabel"
        static let keypadView = "tests--PinKeypadView"
    }
    
    struct PaymentInput {
        static let keypadView = "tests--paymentInputKeypadView"
        static let checkoutButton = "tests--checkoutButton"
        static let amountLabel = "tests--amountLabel"
        static let menuButton = "tests--menuButton"
    }
    
    struct PaymentRequest {
        static let connectionStatusImageView = "tests--connectionStatusImageView"
        static let qrImageView = "tests--qrImageView"
        static let cancelButton = "tests--cancelButton"
    }
    
    struct Settings {
        static let itemsView = "tests--settingsItemsView"
        static let walletAdView = "tests--settingsWalletAdView"
        static let localBitcoinCashAdView = "tests--settingsLocalBitcoinCashAdView"
        static let exchangeAdView = "tests--settingsExchangeAdView"
    }
    
}
