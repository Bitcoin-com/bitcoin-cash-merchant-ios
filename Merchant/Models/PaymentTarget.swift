//
//  PaymentTarget.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/25/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import BitcoinKit

enum PaymentTargetType: Int, Codable {
    case invalid
    case address
    case apiKey
}

final class PaymentTarget: Codable {
    
    // MARK: - Properties
    var target: String
    var legacyAddress: String
    var type: PaymentTargetType
    
    // MARK: - Computed Properties
    var bchAddress: String {
        if type == .address {
            do {
                let cashAddress = try BitcoinAddress(cashaddr: legacyAddress)
                return cashAddress.cashaddr
            } catch {
                AnalyticsService.shared.logEvent(.error_convert_address_to_bch, withError: error)
            }
        }
        
        return legacyAddress
    }
    var invoiceRequestAddress: String? {
        if type == .address {
            return target
        }
        
        return nil
    }
    var invoiceRequestApiKey: String? {
        if type == .apiKey {
            return target
        }
        
        return nil
    }

    // MARK: - Initializer
    init(target: String, type: PaymentTargetType) {
        self.target = target.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.legacyAddress = self.target
        self.type = type
        
        setup()
    }
    
    // MARK: - Private API
    private func setup() {
        type = .invalid
        
        if isApiKey() {
            type = .apiKey
            return
        }

        if isLegacyAddress() {
            type = .address
            updateLegacyAddress()
            return
        } else {
            legacyAddress = "bitcoincash:\(legacyAddress)"
            if isLegacyAddress() {
                type = .address
                updateLegacyAddress()
                return
            }
        }
    }
    
    private func isApiKey() -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "[a-z]{40}").evaluate(with: legacyAddress)
    }
    
    private func isXPub() -> Bool {
        guard let data = Base58.decode(legacyAddress) else { return false }
                
        let xpubBytes = [UInt8](data)
        
        if (xpubBytes.count != 82) { return false }
        
        let fourBytes = [UInt8](xpubBytes[0...3])
        
        let bigEndianValue = fourBytes.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
        }.pointee
        let version = UInt32(bigEndian: bigEndianValue)
        
        if (version != Constants.MAGIC_XPUB && version != Constants.MAGIC_TPUB && version != Constants.MAGIC_YPUB && version != Constants.MAGIC_UPUB && version != Constants.MAGIC_ZPUB && version != Constants.MAGIC_VPUB) {
            return false
        }
        
        let subdata = data.advanced(by: 45)
        let array = [UInt8](subdata.dropLast(subdata.count - 1))
        
        let firstByte = array[0]
        if (firstByte == 0x02 || firstByte == 0x03) {
            return true
        }
        
        return false
    }
    
    private func isLegacyAddress() -> Bool {
        return isLegacy() || isCashAddress()
    }
    
    private func isLegacy() -> Bool {
        do {
            let _ = try BitcoinAddress(legacy: legacyAddress)
            return true
        } catch {
            return false
        }
    }
    
    private func isCashAddress() -> Bool {
        do {
            let _ = try BitcoinAddress(cashaddr: legacyAddress)
            return true
        } catch {
            return false
        }
    }
    
    private func updateLegacyAddress() {
        do {
            let legacy = try BitcoinAddress(legacy: legacyAddress)
            legacyAddress = legacy.cashaddr
        } catch {
            do {
                let cashAddress = try BitcoinAddress(cashaddr: legacyAddress)
                legacyAddress = cashAddress.cashaddr
            } catch {}
        }
    }
    
}

private struct Constants {
    static let MAGIC_XPUB = 0x0488B21E
    static let MAGIC_TPUB = 0x043587CF
    static let MAGIC_YPUB = 0x049D7CB2
    static let MAGIC_UPUB = 0x044A5262
    static let MAGIC_ZPUB = 0x04B24746
    static let MAGIC_VPUB = 0x045F1CF6
}
