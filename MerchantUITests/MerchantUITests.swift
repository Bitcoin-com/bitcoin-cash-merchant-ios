//
//  MerchantUITests.swift
//  MerchantUITests
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import XCTest

class MerchantUITests: XCTestCase {
    
    // MARK: - Properties
    var application: XCUIApplication!
    
    // MARK: - Setup
    override func setUp() {
        continueAfterFailure = false
        
        application = XCUIApplication()
        application.launchArguments += ["UI-Testing"]
        application.launch()
        
        XCUIDevice.shared.orientation = .portrait
    }
    
    // MARK: - Tests
    func testInvoiceCreation() {
        // Payment Input.
        let amountLabel = application.staticTexts[Tests.PaymentInput.amountLabel]
        XCTAssertTrue(amountLabel.exists, "Element should exist")
        
        let keypadView = application.otherElements[Tests.PaymentInput.keypadView]
        XCTAssertTrue(keypadView.exists, "Element should exist")
        
        let button = keypadView.buttons["5"]
        XCTAssertTrue(button.exists, "Element should exist")
        button.tap()
        
        XCTAssertEqual(amountLabel.label, "5")
        
        let checkoutButton = application.buttons[Tests.PaymentInput.checkoutButton]
        XCTAssertTrue(checkoutButton.exists, "Element should exist")
        checkoutButton.tap()
        
        // Payment Request.
        let connectionStatusImageView = self.application.images[Tests.PaymentRequest.connectionStatusImageView]
        let connectionStatusImageViewExists = connectionStatusImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(connectionStatusImageViewExists, "Element should exist")
        
        let qrImageView = self.application.images[Tests.PaymentRequest.qrImageView]
        let qrImageViewExists = qrImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(qrImageViewExists, "Element should exist")
    }
    
    func testInvoiceCancellation() {
        // Payment Input.
        let amountLabel = application.staticTexts[Tests.PaymentInput.amountLabel]
        XCTAssertTrue(amountLabel.exists, "Element should exist")
        
        let keypadView = application.otherElements[Tests.PaymentInput.keypadView]
        XCTAssertTrue(keypadView.exists, "Element should exist")
        
        let button = keypadView.buttons["5"]
        XCTAssertTrue(button.exists, "Element should exist")
        button.tap()
        
        XCTAssertEqual(amountLabel.label, "5")
        
        let checkoutButton = application.buttons[Tests.PaymentInput.checkoutButton]
        XCTAssertTrue(checkoutButton.exists, "Element should exist")
        checkoutButton.tap()
        
        // Payment Request.
        let connectionStatusImageView = self.application.images[Tests.PaymentRequest.connectionStatusImageView]
        let connectionStatusImageViewExists = connectionStatusImageView.waitForExistence(timeout: 2)
        XCTAssertTrue(connectionStatusImageViewExists, "Element should exist")
        
        let qrImageView = self.application.images[Tests.PaymentRequest.qrImageView]
        let qrImageViewExists = qrImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(qrImageViewExists, "Element should exist")
        
        let cancelButton = self.application.buttons[Tests.PaymentRequest.cancelButton]
        let cancelButtonExists = cancelButton.waitForExistence(timeout: 2)
        XCTAssertTrue(cancelButtonExists, "Element should exist")
        
        cancelButton.tap()
        
        let amountLabelExists = amountLabel.waitForExistence(timeout: 2)
        XCTAssertTrue(amountLabelExists, "Element should exist")
    }
    
}
