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
    
    func logEvent(_ event: Event, withError error: Error) {
        Amplitude.instance()?.logEvent(event.rawValue, withEventProperties: [
            "error": error.localizedDescription
        ])
    }
    
}

enum Event: String {
    case invoice_checkout
    case invoice_created
    case invoice_cancelled
    case invoice_paid
    case invoice_shared
    
    case settings_merchantname_edit
    case settings_merchantname_changed
    case settings_currency_edit
    case settings_currency_changed
    case settings_pin_edit
    case settings_pin_changed
    case settings_paymenttarget_edit
    case settings_paymenttarget_changed
    case settings_paymenttarget_pairingcode_set
    case settings_paymenttarget_xpub_set
    case settings_paymenttarget_pubkey_set
    case settings_paymenttarget_apikey_set
    
    case tap_settings
    case tap_wallet
    case tap_localbitcoin
    case tap_exchange
    case tap_privacypolicy
    case tap_serviceterms
    case tap_termsofuse
    case tap_about
    case tap_transactions
    
    case tx_id_explorer_launched
    case tx_id_copied
    case tx_address_explorer_launched
    case tx_address_copied
    
    case error_db_write_tx
    case error_db_read_tx
    case error_db_read_address
    case error_db_unknown
    case error_rendering
    case error_syncing_xpub
    case error_rest_bitcoin_com_scan_address_funds
    case error_copy_to_clipboard
    case error_generate_address_from_xpub
    case error_download_invoice
    case error_connect_to_socket
    case error_generate_qr_code
    case error_convert_address_to_bch
    case error_format_currency
}
