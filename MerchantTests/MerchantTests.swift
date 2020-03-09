//
//  MerchantTests.swift
//  MerchantTests
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import XCTest
@testable import Merchant

class MerchantTests: XCTestCase {
    
    // MARK: - Properties
    private let bip70service = BIP70Service.shared
    
    // MARK: - Tests
    
    // MARK: - Create Invoice
    func testCreateInvoice() {
        let requestExpectation = expectation(description: "Request Expectation")
        
        let invoice = InvoiceRequest(fiatAmount: 500.57,
                                     fiat: "USD",
                                     apiKey: "sexqvmkxafvzhzfageoojrkchdekfwmuqpfqywsf",
                                     address: "qqkzr47vfa8p48urteqer5dxsmwqkc3c7qjnlt0h2e")
        
        
        bip70service.createInvoice(invoice) { result in
            requestExpectation.fulfill()
            
            switch result {
            case .success(let data):
                let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                if let invoiceStatus = invoiceStatus {
                    XCTAssertTrue(invoiceStatus.status == "open", "InvoiceStatus should be open")
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
