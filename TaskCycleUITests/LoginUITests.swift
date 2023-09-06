//
//  LoginUITests.swift
//  TaskCycleUITests
//
//  Created by Eyüp on 2023-09-03.
//

import XCTest

final class LoginUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testValidLoginProcess() throws {
        let app = XCUIApplication()
        app.launch()

        let emailTextField = app.textFields.element
        let emailTextFieldExist = emailTextField.placeholderValue == "Enter Email"
        XCTAssertTrue(emailTextFieldExist, "Email Textfield could not find")

        emailTextField.tap()
        emailTextField.typeText("test@gmail.com")

        let passwordTextField = app.secureTextFields.element
        let passwordTextFieldExists = passwordTextField.placeholderValue == "Enter Password"
        XCTAssertTrue(passwordTextFieldExists, "Password Textfield could not find")

        passwordTextField.tap()
        passwordTextField.typeText("123123")

        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login Button could not find")

        loginButton.tap()

        // Wait for the transition to complete. Use XCTWaiter or other mechanisms to wait.
        let expectation = XCTestExpectation(description: "Wait for new page to appear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        XCTWaiter().wait(for: [expectation], timeout: 10.0)

        // Assert that the login screen's elements no longer exist
        let emailTextFieldStillExist = app.textFields.element.placeholderValue == "Enter Email"
        XCTAssertFalse(emailTextFieldStillExist, "Email Textfield still exists after login")
    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
