//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Nataliya TRUFANOVA on 09/01/2024.
//

@testable import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    let login = ""
    let password = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        if authButton.waitForExistence(timeout: 10) {
            authButton.tap()
        } else {
            XCTFail("Authenticate button not found")
        }
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.firstMatch.waitForExistence(timeout: 10))
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButton = cellToLike.buttons["LikeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 10))
        
        likeButton.tap()
        sleep(4)
        
        likeButton.tap()
        sleep(4)
        
        cellToLike.tap()
        sleep(4)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10))
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["Backward_nav_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let nameLabel = app.staticTexts["nameLabel"]
        let loginNameLabel = app.staticTexts["loginNameLabel"]
        
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 10))
        XCTAssertTrue(loginNameLabel.waitForExistence(timeout: 10))
        
        let logoutButton = app.buttons["logout_button"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 10))
        logoutButton.tap()
        
        let alertButton = app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"]
        XCTAssertTrue(alertButton.waitForExistence(timeout: 10))
        alertButton.tap()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10))
    }
}
