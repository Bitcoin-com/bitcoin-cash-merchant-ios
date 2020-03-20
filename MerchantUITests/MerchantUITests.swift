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
        
        UIPasteboard.general.string = "bitcoincash:qqqclals9tfg7vvd3xqdkgk7nn569ap7kgwjhqzedm"
    }
    
    // MARK: - Tests
    
    // MARK: - PIN
    func testCreatePINSuccessful() {
        // Create PIN.
        let keypadView = application.otherElements[Tests.Pin.keypadView]
        XCTAssertTrue(keypadView.exists)
        let button = keypadView.buttons["1"]
        XCTAssertTrue(button.exists)
        
        // Create PIN.
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        // Confirm PIN.
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
    }
    
    func testCreatePINFailure() {
        // Create PIN.
        let keypadView = application.otherElements[Tests.Pin.keypadView]
        XCTAssertTrue(keypadView.exists)
        let button = keypadView.buttons["1"]
        XCTAssertTrue(button.exists)
        
        // Create PIN.
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        // Confirm PIN.
        button.tap()
        button.tap()
        button.tap()
        
        let wrongButton = keypadView.buttons["2"]
        wrongButton.tap()
        
        // Pin.
        let explanationLabel = application.staticTexts[Tests.Pin.explanationLabel]
        XCTAssertTrue(explanationLabel.exists)
        
        XCTAssertTrue(explanationLabel.label == "Create PIN Code")
    }
    
    // MARK: - Settings
    func testEnterMerchantName() {
        testCreatePINSuccessful()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let merchantCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(merchantCell.exists)
        merchantCell.tap()
        
        // Merchant Name alert.
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let textField = alert.textFields.firstMatch
        XCTAssertTrue(textField.exists)
        textField.typeText("Djuro")
        alert.buttons["OK"].tap()
    }
    
    func testEnterDestinationAddressSuccessful() {
        testCreatePINSuccessful()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let destinationAddressCell = tableView.cells.element(boundBy: 1)
        XCTAssertTrue(destinationAddressCell.exists)
        destinationAddressCell.tap()
        
        // Destination Address alert.
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let pasteButton = alert.buttons["Paste"]
        XCTAssertTrue(pasteButton.exists)
        pasteButton.tap()
    }
    
    func testSelectCurrency() {
        testCreatePINSuccessful()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let countryCurrencyCell = tableView.cells.element(boundBy: 2)
        XCTAssertTrue(countryCurrencyCell.exists)
        countryCurrencyCell.tap()
        
        sleep(1)
        
        let currenciesItemsView = application.otherElements[Tests.Currencies.itemsView]
        XCTAssertTrue(currenciesItemsView.exists)
        
        let currenciesTableView = currenciesItemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(currenciesTableView.exists)
        let currencyCell = currenciesTableView.cells.element(boundBy: 219) // USD: 219
        XCTAssertTrue(currencyCell.exists)
        currencyCell.tap()
        
        sleep(1)
    }
    
    func testUpdatePin() {
        testCreatePINSuccessful()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let pinCell = tableView.cells.element(boundBy: 3)
        XCTAssertTrue(pinCell.exists)
        pinCell.tap()
        
        sleep(1)
        
        // Update PIN.
        let keypadView = application.otherElements[Tests.Pin.keypadView]
        XCTAssertTrue(keypadView.exists)
        let button = keypadView.buttons["2"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        XCTAssertTrue(itemsView.exists)
    }
    
    func testEnterMerchantNameTryToGoBackWithoutEnteringDestinationAddress() {
        testCreatePINSuccessful()
        
        // Settings.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let merchantCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(merchantCell.exists)
        merchantCell.tap()
        
        // Merchant Name alert.
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let textField = alert.textFields.firstMatch
        XCTAssertTrue(textField.exists)
        textField.typeText("Djuro")
        alert.buttons["OK"].tap()
        
        sleep(1)
        
        // Tap on Back.
        let navigationBar = application.otherElements[Tests.NavigationBar.identifier]
        XCTAssertTrue(navigationBar.exists)
        let closeButton = navigationBar.buttons[Tests.NavigationBar.closeButton]
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()
        
        // Error alert.
        let errorAlert = application.alerts.firstMatch
        XCTAssertTrue(errorAlert.exists)
    }
    
    func testDataSavedAndUserReadyForCreatingInvoices() {
        testEnterMerchantName()
        
        sleep(1)
        
        // Enter Destination Address.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let merchantCell = tableView.cells.element(boundBy: 1)
        XCTAssertTrue(merchantCell.exists)
        merchantCell.tap()
        
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let pasteButton = alert.buttons["Paste"]
        XCTAssertTrue(pasteButton.exists)
        pasteButton.tap()
        
        sleep(3)
        
        // Tap on Back.
        let navigationBar = application.otherElements[Tests.NavigationBar.identifier]
        XCTAssertTrue(navigationBar.exists)
        let closeButton = navigationBar.buttons[Tests.NavigationBar.closeButton]
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()
        
        sleep(1)
        
        // Amount label.
        let amountLabel = application.staticTexts[Tests.PaymentInput.amountLabel]
        XCTAssertTrue(amountLabel.exists)
    }
    
    func testTapOnWalletAdView() {
        testCreatePINSuccessful()
        
        // Ad View.
        let adView = application.otherElements[Tests.Settings.walletAdView]
        XCTAssertTrue(adView.exists)
        adView.tap()
    }
    
    func testTapOnLocalBitcoinCashAdView() {
        testCreatePINSuccessful()
        
        // Ad View.
        let adView = application.otherElements[Tests.Settings.localBitcoinCashAdView]
        XCTAssertTrue(adView.exists)
        adView.tap()
    }
    
    func testTapOnExchangeAdView() {
        testCreatePINSuccessful()
        
        // Ad View.
        let adView = application.otherElements[Tests.Settings.exchangeAdView]
        XCTAssertTrue(adView.exists)
        adView.tap()
    }
    
    // MARK: - Payment Input
    func testInvoiceCreation() {
        testEnterMerchantName()
        
        sleep(1)
        
        // Enter Destination Address.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let merchantCell = tableView.cells.element(boundBy: 1)
        XCTAssertTrue(merchantCell.exists)
        merchantCell.tap()
        
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let pasteButton = alert.buttons["Paste"]
        XCTAssertTrue(pasteButton.exists)
        pasteButton.tap()
        
        sleep(2)
        
        // Tap on Back.
        let navigationBar = application.otherElements[Tests.NavigationBar.identifier]
        XCTAssertTrue(navigationBar.exists)
        let closeButton = navigationBar.buttons[Tests.NavigationBar.closeButton]
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()
        
        sleep(1)
        
        // Payment Input.
        let amountLabel = application.staticTexts[Tests.PaymentInput.amountLabel]
        XCTAssertTrue(amountLabel.exists)

        let keypadView = application.otherElements[Tests.PaymentInput.keypadView]
        XCTAssertTrue(keypadView.exists)
        
        sleep(1)

        let button = keypadView.buttons["5"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)

        XCTAssertEqual(amountLabel.label, "5")

        let checkoutButton = application.buttons[Tests.PaymentInput.checkoutButton]
        XCTAssertTrue(checkoutButton.exists)
        checkoutButton.tap()

        // Payment Request.
        let connectionStatusImageView = application.images[Tests.PaymentRequest.connectionStatusImageView]
        let connectionStatusImageViewExists = connectionStatusImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(connectionStatusImageViewExists)

        let qrImageView = application.images[Tests.PaymentRequest.qrImageView]
        let qrImageViewExists = qrImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(qrImageViewExists)
    }

    func testInvoiceCancellation() {
        testEnterMerchantName()
        
        sleep(1)
        
        // Enter Destination Address.
        let itemsView = application.otherElements[Tests.Settings.itemsView]
        XCTAssertTrue(itemsView.exists)
        
        let tableView = itemsView.tables[Tests.ItemsView.tableView]
        XCTAssertTrue(tableView.exists)
        let merchantCell = tableView.cells.element(boundBy: 1)
        XCTAssertTrue(merchantCell.exists)
        merchantCell.tap()
        
        let alert = application.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
        let pasteButton = alert.buttons["Paste"]
        XCTAssertTrue(pasteButton.exists)
        pasteButton.tap()
        
        sleep(2)
        
        // Tap on Back.
        let navigationBar = application.otherElements[Tests.NavigationBar.identifier]
        XCTAssertTrue(navigationBar.exists)
        let closeButton = navigationBar.buttons[Tests.NavigationBar.closeButton]
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()
        
        sleep(1)
        
        // Payment Input.
        let amountLabel = application.staticTexts[Tests.PaymentInput.amountLabel]
        XCTAssertTrue(amountLabel.exists)

        let keypadView = application.otherElements[Tests.PaymentInput.keypadView]
        XCTAssertTrue(keypadView.exists)
        
        sleep(1)

        let button = keypadView.buttons["5"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)

        XCTAssertEqual(amountLabel.label, "5")

        let checkoutButton = application.buttons[Tests.PaymentInput.checkoutButton]
        XCTAssertTrue(checkoutButton.exists)
        checkoutButton.tap()

        // Payment Request.
        let connectionStatusImageView = application.images[Tests.PaymentRequest.connectionStatusImageView]
        let connectionStatusImageViewExists = connectionStatusImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(connectionStatusImageViewExists)

        let qrImageView = application.images[Tests.PaymentRequest.qrImageView]
        let qrImageViewExists = qrImageView.waitForExistence(timeout: 3)
        XCTAssertTrue(qrImageViewExists)
        
        let cancelButton = application.buttons[Tests.PaymentRequest.cancelButton]
        XCTAssertTrue(cancelButton.exists)

        cancelButton.tap()

        let amountLabelExists = amountLabel.waitForExistence(timeout: 2)
        XCTAssertTrue(amountLabelExists)
    }
    
    func testMenuButtonExists() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
    }
    
    // MARK: - Transactions
    func testTransactionsTableViewExists() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        sleep(1)
        
        // Side Menu.
        let sideMenuTableView = application.tables[Tests.SideMenu.tableView]
        XCTAssertTrue(sideMenuTableView.exists)
        let transactionsCell = sideMenuTableView.cells.element(boundBy: 0)
        XCTAssertTrue(transactionsCell.exists)
        transactionsCell.tap()
        
        sleep(1)
        
        // Transactions
        XCTAssertTrue(application.tables[Tests.Transactions.tableView].exists)
        XCTAssertTrue(application.images[Tests.Transactions.noHistoryImageView].exists)
        XCTAssertTrue(application.staticTexts[Tests.Transactions.noHistoryLabel].exists)
    }
    
    // MARK: - Side Menu
    func testTermsOfUseTap() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        sleep(1)
        
        // Terms of Use.
        let sideMenuTableView = application.tables[Tests.SideMenu.tableView]
        XCTAssertTrue(sideMenuTableView.exists)
        let cell = sideMenuTableView.cells.element(boundBy: 2)
        XCTAssertTrue(cell.exists)
        cell.tap()
    }
    
    func testServiceTermsTap() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        sleep(1)
        
        // Service Terms.
        let sideMenuTableView = application.tables[Tests.SideMenu.tableView]
        XCTAssertTrue(sideMenuTableView.exists)
        let cell = sideMenuTableView.cells.element(boundBy: 3)
        XCTAssertTrue(cell.exists)
        cell.tap()
    }
    
    func testPrivacyPolicyTap() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        sleep(1)
        
        // Privacy Policy.
        let sideMenuTableView = application.tables[Tests.SideMenu.tableView]
        XCTAssertTrue(sideMenuTableView.exists)
        let cell = sideMenuTableView.cells.element(boundBy: 4)
        XCTAssertTrue(cell.exists)
        cell.tap()
    }
    
    func testAboutTap() {
        testDataSavedAndUserReadyForCreatingInvoices()
        
        // Menu Button.
        let menuButton = application.buttons[Tests.PaymentInput.menuButton]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        sleep(1)
        
        // About.
        let sideMenuTableView = application.tables[Tests.SideMenu.tableView]
        XCTAssertTrue(sideMenuTableView.exists)
        let cell = sideMenuTableView.cells.element(boundBy: 5)
        XCTAssertTrue(cell.exists)
        cell.tap()
    }
    
}

extension XCUIElement {
    
    func forceTapElement() {
        if isHittable {
            tap()
        } else {
            let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
    
}
