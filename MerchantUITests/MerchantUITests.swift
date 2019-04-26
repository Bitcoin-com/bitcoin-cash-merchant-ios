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

    func testFlow() {
        let app = XCUIApplication()
        app.navigationBars.firstMatch.buttons["settings icon"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Company name").children(matching: .textField).element.tap()
        
        tablesQuery.cells.containing(.staticText, identifier:"Destination address").children(matching: .textField).element.tap()
        
        let addressTextField = tablesQuery.cells.containing(.staticText, identifier:"Destination address").children(matching: .textField).element
       
        addressTextField.tap()
        
        // Clean
        let deleteString = (0..<60).map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
        addressTextField.typeText(deleteString)
        
        // Type the address
        addressTextField.typeText("bitcoincash:pzmgrnkszxvw0r5n0hh66jhcj6p0zpc6xv9xal297t")
        
        app.navigationBars["Settings"].buttons["close icon"].tap()
        app.tabBars.buttons["History"].tap()
        
//        let transactionCell = app.tables.cells.containing(.staticText, identifier:"Today at 7:00").staticTexts["$ 100,00"]
//        
//        transactionCell.tap()
//        app.sheets.buttons["View transaction on explorer"].tap()
//        
//        transactionCell.tap()
//        app.sheets.buttons["View address on explorer"].tap()
//        
//        transactionCell.tap()
//        app.sheets.buttons["Copy transaction"].tap()
        
        app.tabBars.buttons["Payment"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["1"].tap()
        collectionViewsQuery.buttons["5"].tap()
        collectionViewsQuery.buttons["8"].tap()
        collectionViewsQuery.buttons["checkmark icon"].tap()
        app.navigationBars["Payment request"].buttons["close icon"].tap()
        
    }

}
