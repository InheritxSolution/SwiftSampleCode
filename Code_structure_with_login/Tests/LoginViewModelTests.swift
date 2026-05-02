//
//  LoginViewModelTests.swift
//  Inheritx Solutions
//

import XCTest
@testable import Code_structure_with_login

class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldReturnSuccess = true
    var loginCalled = false
    
    func login(parameters: [String : Any], completion: @escaping (Result<UserModel, Error>) -> Void) {
        loginCalled = true
        if shouldReturnSuccess {
            let user = UserModel(success: true, token: "test_token", data: nil)
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "Test", code: 401, userInfo: nil)))
        }
    }
}

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockService: MockAuthenticationService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthenticationService()
        viewModel = LoginViewModel(authService: mockService)
    }
    
    func testValidation_EmptyEmail_ReturnsFalse() {
        let result = viewModel.validate(email: "", password: "password")
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.emailErrorMessage, "Email is required")
    }
    
    func testValidation_InvalidEmail_ReturnsFalse() {
        let result = viewModel.validate(email: "invalid-email", password: "password")
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.emailErrorMessage, "Please enter a valid email")
    }
    
    func testValidation_ValidInput_ReturnsTrue() {
        let result = viewModel.validate(email: "test@example.com", password: "password")
        XCTAssertTrue(result)
        XCTAssertNil(viewModel.emailErrorMessage)
        XCTAssertNil(viewModel.passwordErrorMessage)
    }
    
    func testLogin_Success_CallsOnLoginSuccess() {
        let expectation = self.expectation(description: "Login Success")
        viewModel.onLoginSuccess = {
            expectation.fulfill()
        }
        
        viewModel.login(email: "test@example.com", password: "password")
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockService.loginCalled)
    }
}
