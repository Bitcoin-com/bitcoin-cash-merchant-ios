//
//  Keys.example.swift
//  Merchant
//
//  TEMPLATE — copy this file to `Keys.swift` (which is gitignored) and fill in the
//  real values. Keep this template free of secrets so it can be committed.
//
//  IMPORTANT: do NOT add this template to the Merchant build target — only `Keys.swift`
//  should be compiled, otherwise `enum Keys` is defined twice (duplicate symbol).
//

import Foundation

enum Keys {
    // BCR live exchange-rate prices endpoint.
    // Get the real value from the Android BCR `apikey.properties` (`pricesUrl`) — confidential.
    // Returns: { "rates": [ { "ccy": "usd", "rate": <fiat per 1 BCH>, ... } ] }
    static let pricesURL = "https://<prices-host>/<path>"
}
