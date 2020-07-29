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
        let target = PaymentTarget(target: "bitcoincash:qzg0jqca4c38uzmkqlqwqgnpemdup9u8hsjyvyc0tz", type: .address)
        
        XCTAssertTrue(target.type == .address, "Bitcoin address should be valid")
    }
    
    func testIsValidBitcoinAddressWithoutBitcoinCashPrefix() {
        let target = PaymentTarget(target: "qzg0jqca4c38uzmkqlqwqgnpemdup9u8hsjyvyc0tz", type: .address)
        
        XCTAssertTrue(target.type == .address, "Bitcoin address should be valid")
    }
    
    func testIsInvalidBitcoinAddress() {
        let target = PaymentTarget(target: "bchtest:qpjdpjrm5zvp2al5u4uzmp36t9m0ll7gd525rss978", type: .invalid)
        
        XCTAssertTrue(target.type == .invalid, "Bitcoin address should be invalid")
    }
    
    func testIsValidPubKeyLegacyFormat() {
        let target = PaymentTarget(target: "1EDYcHyFgvFm9ZGqdLwjKxZtZUph5i7EQq", type: .address)
        
        XCTAssertTrue(target.type == .address, "Pub Key legacy format should be valid")
    }
    
    func testIsValidPubKeyLegacyFormatWithWhitespaceCharactersIncluded() {
        let target = PaymentTarget(target: " 1EDYcHyFgvFm9ZGqdLwjKxZtZUph5i7EQq ", type: .address)
        
        XCTAssertTrue(target.type == .address, "Pub Key legacy format should be valid")
    }
    
    func testIsValidApiKey() {
        let target = PaymentTarget(target: "dtgmfljtkcbwwvkbegpakhwseymimpalanmqjtae", type: .apiKey)
        
        XCTAssertTrue(target.type == .apiKey, "Api Key should be valid")
    }
    
    func testIsValidP2SH() {
        let target = PaymentTarget(target: "3CSUDH5yW1KHJmMDHfCCWShWgJkbVnfvnJ", type: .address)
        
        XCTAssertTrue(target.type == .address, "P2SH should be valid")
    }
}
