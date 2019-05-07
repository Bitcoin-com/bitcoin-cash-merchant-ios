//
//  MerchantUITests.swift
//  MerchantUITests
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import XCTest

class MerchantUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["MerchantUITests"]
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicFlow() {
        
        let app = XCUIApplication()
        
        let closeButton = app.navigationBars.buttons["close icon"]
        let settingsButton = app.navigationBars.buttons["settings icon"]
        let checkmarkButton = app.collectionViews.buttons["checkmark icon"]
        
        let button1 = app.collectionViews.buttons["1"]
        let button2 = app.collectionViews.buttons["2"]
        
        // Set PIN
        button1.tap()
        button1.tap()
        button2.tap()
        button2.tap()
        
        // Confirm PIN
        button1.tap()
        button1.tap()
        button2.tap()
        button2.tap()
        
        let okButton = app.alerts.firstMatch.buttons["Ok"]
        okButton.tap()
        
        button1.tap()
        button1.tap()
        
        checkmarkButton.tap()
        
        app.alerts.firstMatch.buttons["Settings"].tap()
        
        button1.tap()
        button1.tap()
        button2.tap()
        button2.tap()
        
        // Clean
        let deleteString = (0..<60).map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
        
        let companyTextField = app.tables.cells.containing(.staticText, identifier:"Company name").children(matching: .textField).element
        
        companyTextField.tap()
        companyTextField.typeText(deleteString)
        companyTextField.typeText("My company")
        
        let addressTextField = app.tables.cells.containing(.staticText, identifier:"Destination address").children(matching: .textField).element
        
        addressTextField.tap()
        addressTextField.typeText("bitcoincash:pqazqrn4l2pve9luh6s3xn2z94pvwtnpavn6ecz0fj")

        app.tables.buttons["Change"].tap()
        
        button1.tap()
        button1.tap()
        button2.tap()
        button2.tap()
        
        button1.tap()
        button1.tap()
        button1.tap()
        button1.tap()
        
        button1.tap()
        button1.tap()
        button1.tap()
        button1.tap()
        
        okButton.tap()
        
        closeButton.tap()
        
        app.navigationBars["My company"].tap()
        app.staticTexts["$ 11,00"].tap()
        
        settingsButton.tap()
        
        button1.tap()
        button1.tap()
        button1.tap()
        button1.tap()
        
        closeButton.tap()
        
        checkmarkButton.tap()
        
        app.staticTexts["Waiting for payment"].tap()
        app.staticTexts["$ 11,00"].firstMatch.tap()
        
        closeButton.tap()
    }
}
