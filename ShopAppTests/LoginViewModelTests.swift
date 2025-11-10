//
//  LoginViewModelTests.swift
//  ShopAppTests
//
//  Created by mohamed ezz on 09/11/2025.
//
//
//  LoginViewModelTests.swift
//  ShopAppTests
//
//  Created by mohamed ezz on 09/11/2025.
//
/*

import Foundation

    func login(email: String, password: String) async throws -> Bool {
//        if shouldThrowError { throw errorToThrow }
        return shouldSucceed
    }
}

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockFirebase: MockFirebaseHelper!
    
    override func setUp() async throws {
//        try await super.setUp()
        await MainActor.run {
            mockFirebase = MockFirebaseHelper()
            viewModel = LoginViewModel(firebaseHelper: mockFirebase)
        }
    }
    
    override func tearDown() async throws {
        await MainActor.run {
            viewModel = nil
            mockFirebase = nil
        }
        try await super.tearDown()
    }
    
    func testLoginFails_WhenFieldsEmpty() async {
        await MainActor.run {
            viewModel.email = ""
            viewModel.password = ""
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertFalse(result)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Please fill all fields correctly.")
        }
    }
    
    func testLoginFails_WhenEmailInvalid() async {
        await MainActor.run {
            viewModel.email = "invalidEmail"
            viewModel.password = "123456"
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertFalse(result)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Please enter a valid email.")
        }
    }
    
    func testLoginFails_WhenPasswordTooShort() async {
        await MainActor.run {
            viewModel.email = "test@example.com"
            viewModel.password = "123"
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertFalse(result)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Password must be at least 6 characters.")
        }
    }
    
    func testLoginSucceeds_WhenVerifiedUser() async {
        await MainActor.run {
            viewModel.email = "test@example.com"
            viewModel.password = "123456"
            mockFirebase.shouldSucceed = true
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertTrue(result)
            XCTAssertFalse(viewModel.showAlert)
        }
    }
    
    func testLoginFails_WhenEmailNotVerified() async {
        await MainActor.run {
            viewModel.email = "test@example.com"
            viewModel.password = "123456"
            mockFirebase.shouldSucceed = false
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertFalse(result)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Email not verified. Please check your inbox.")
        }
    }
    
    func testLoginFails_WhenFirebaseThrowsError() async {
        await MainActor.run {
            viewModel.email = "test@example.com"
            viewModel.password = "123456"
            mockFirebase.shouldThrowError = true
        }
        
        let result = await viewModel.login()
        
        await MainActor.run {
            XCTAssertFalse(result)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Mock error")
        }
    }
}
*/
