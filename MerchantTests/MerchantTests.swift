//
//  MerchantTests.swift
//  MerchantTests
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import XCTest
@testable import Bitcoin_Cash_Register

class MerchantTests: XCTestCase {
    
    // MARK: - Properties
    private let bip70service = BIP70Service.shared
    
    // MARK: - Tests
    
    // MARK: - Creating Invoices and QR Code generation
    func testCreateInvoiceBitcoinAddress() {
        let requestExpectation = expectation(description: "Request Expectation")
        
        let target = PaymentTarget(target: "bitcoincash:qzg0jqca4c38uzmkqlqwqgnpemdup9u8hsjyvyc0tz", type: .address)
        
        let invoice = InvoiceRequest(fiatAmount: 500.57,
                                     fiat: "USD",
                                     apiKey: target.invoiceRequestApiKey,
                                     address: target.invoiceRequestAddress)
        
        bip70service.createInvoice(invoice) { result in
            requestExpectation.fulfill()
            
            switch result {
            case .success(let data):
                let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                if let invoiceStatus = invoiceStatus {
                    XCTAssertTrue(invoiceStatus.status == "open", "InvoiceStatus should be open")
                    
                    if let url = URL(string: "\(Endpoints.wallet)\(BASE_URL)/i/\(invoiceStatus.paymentId)") {
                        XCTAssertNotNil(url.qrImage, "QR Code should be generated")
                    } else {
                        XCTFail("QR Code not generated")
                    }
                } else {
                    XCTFail("Invoice status not parsed")
                }
            case .failure(let error):
                XCTFail("Error occurred: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: { (error) in
            if error != nil {
                XCTFail("Request timed out")
            }
        })
    }
    
    func testCreateInvoiceApiKey() {
        let requestExpectation = expectation(description: "Request Expectation")
        
        let target = PaymentTarget(target: "sexqvmkxafvzhzfageoojrkchdekfwmuqpfqywsf", type: .apiKey)
        
        let invoice = InvoiceRequest(fiatAmount: 500.57,
                                     fiat: "USD",
                                     apiKey: target.invoiceRequestApiKey,
                                     address: target.invoiceRequestAddress)
        
        bip70service.createInvoice(invoice) { result in
            requestExpectation.fulfill()
            
            switch result {
            case .success(let data):
                let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                if let invoiceStatus = invoiceStatus {
                    XCTAssertTrue(invoiceStatus.status == "open", "InvoiceStatus should be open")
                    
                    if let url = URL(string: "\(Endpoints.wallet)\(BASE_URL)/i/\(invoiceStatus.paymentId)") {
                        XCTAssertNotNil(url.qrImage, "QR Code should be generated")
                    } else {
                        XCTFail("QR Code not generated")
                    }
                } else {
                    XCTFail("Invoice status not parsed")
                }
            case .failure(let error):
                XCTFail("Error occurred: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: { (error) in
            if error != nil {
                XCTFail("Request timed out")
            }
        })
    }
    
    func testCreateInvoiceXPubKey() {
        let requestExpectation = expectation(description: "Request Expectation")
        
        let target = PaymentTarget(target: "xpub6CUGRUonZSQ4TWtTMmzXdrXDtypWKiKrhko4egpiMZbpiaQL2jkwSB1icqYh2cfDfVxdx4df189oLKnC5fSwqPfgyP3hooxujYzAu3fDVmz", type: .xPub)
        
        let invoice = InvoiceRequest(fiatAmount: 500.57,
                                     fiat: "USD",
                                     apiKey: target.invoiceRequestApiKey,
                                     address: target.invoiceRequestAddress)
        
        bip70service.createInvoice(invoice) { result in
            requestExpectation.fulfill()
            
            switch result {
            case .success(let data):
                let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                if let invoiceStatus = invoiceStatus {
                    XCTAssertTrue(invoiceStatus.status == "open", "InvoiceStatus should be open")
                    
                    if let url = URL(string: "\(Endpoints.wallet)\(BASE_URL)/i/\(invoiceStatus.paymentId)") {
                        XCTAssertNotNil(url.qrImage, "QR Code should be generated")
                    } else {
                        XCTFail("QR Code not generated")
                    }
                } else {
                    XCTFail("Invoice status not parsed")
                }
            case .failure(let error):
                XCTFail("Error occurred: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: { (error) in
            if error != nil {
                XCTFail("Request timed out")
            }
        })
    }
    
}
