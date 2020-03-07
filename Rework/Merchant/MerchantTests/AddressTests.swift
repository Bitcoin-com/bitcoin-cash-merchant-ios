//
//  AddressTests.swift
//  MerchantTests
//
//  Created by Djuro Alfirevic on 3/5/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import XCTest
@testable import Merchant

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
        let target = PaymentTarget(address: "bchtest:qzgmyjle755g2v5kptrg02asx5f8k8fg55xlze46jr", type: .invalid)
        
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
        let target = PaymentTarget(address: "3CSUDH5yW1KHJmMDHfCCWShWgJkbVnfvnJ (legacy)", type: .address)
        
        XCTAssertTrue(target.type == .address, "P2SH should be valid")
    }
    
    func testIsValidXPubKey() {
        let xPubKey = "xpub6CUGRUonZSQ4TWtTMmzXdrXDtypWKiKrhko4egpiMZbpiaQL2jkwSB1icqYh2cfDfVxdx4df189oLKnC5fSwqPfgyP3hooxujYzAu3fDVmz"
        let target = PaymentTarget(address: xPubKey, type: .xPub)
        
        XCTAssertTrue(target.type == .xPub, "xPubKey should be valid")
    }
    
}
