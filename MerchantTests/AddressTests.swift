//
//  AddressTests.swift
//  MerchantTests
//
//  Created by Djuro Alfirevic on 3/5/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import XCTest
import BitcoinKit
@testable import Bitcoin_Cash_Register

class AddressTests: XCTestCase {
    
    // MARK: - Tests
    
    // MARK: - Address Formats
    func testIsValidBitcoinAddressWithBitcoinCashPrefix() {
        let target = PaymentTarget(address: "bitcoincash:qzg0jqca4c38uzmkqlqwqgnpemdup9u8hsjyvyc0tz", type: .address)
        
        XCTAssertTrue(target.type == .address, "Bitcoin address should be valid")
    }
    
    func testIsValidBitcoinAddressWithoutBitcoinCashPrefix() {
        let target = PaymentTarget(address: "qzg0jqca4c38uzmkqlqwqgnpemdup9u8hsjyvyc0tz", type: .address)
        
        XCTAssertTrue(target.type == .address, "Bitcoin address should be valid")
    }
    
    func testIsInvalidBitcoinAddress() {
        let target = PaymentTarget(address: "bchtest:qpjdpjrm5zvp2al5u4uzmp36t9m0ll7gd525rss978", type: .invalid)
        
        XCTAssertTrue(target.type == .invalid, "Bitcoin address should be invalid")
    }
    
    func testIsValidPubKeyLegacyFormat() {
        let target = PaymentTarget(address: "1EDYcHyFgvFm9ZGqdLwjKxZtZUph5i7EQq", type: .address)
        
        XCTAssertTrue(target.type == .address, "Pub Key legacy format should be valid")
    }
    
    func testIsValidApiKey() {
        let target = PaymentTarget(address: "dtgmfljtkcbwwvkbegpakhwseymimpalanmqjtae", type: .apiKey)
        
        XCTAssertTrue(target.type == .apiKey, "Api Key should be valid")
    }
    
    func testIsValidP2SH() {
        let target = PaymentTarget(address: "3CSUDH5yW1KHJmMDHfCCWShWgJkbVnfvnJ", type: .address)
        
        XCTAssertTrue(target.type == .address, "P2SH should be valid")
    }
    
    func testIsValidXPubKey() {
        let xPubKeys = [
            "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"
        ]
        
        xPubKeys.forEach {
            let target = PaymentTarget(address: $0, type: .xPub)
            
            XCTAssertTrue(target.type == .xPub, "xPubKey should be valid")
        }
    }
    
}
