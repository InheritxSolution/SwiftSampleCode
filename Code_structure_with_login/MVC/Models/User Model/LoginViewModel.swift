//
//  LoginViewModel.swift
//  Inheritx Solutions
//

import Foundation

class LoginViewModel {
    
    private let authService: AuthenticationServiceProtocol
    
    // Bindable properties
    var onShowError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    
    var emailErrorMessage: String?
    var passwordErrorMessage: String?
    
    init(authService: AuthenticationServiceProtocol = AuthenticationService()) {
        self.authService = authService
    }
    
    func validate(email: String?, password: String?) -> Bool {
        var isValid = true
        
        if (email ?? "").isEmpty {
            emailErrorMessage = "Email is required"
            isValid = false
        } else if !isValidEmail(email ?? "") {
            emailErrorMessage = "Please enter a valid email"
            isValid = false
        } else {
            emailErrorMessage = nil
        }
        
        if (password ?? "").isEmpty {
            passwordErrorMessage = "Password is required"
            isValid = false
        } else {
            passwordErrorMessage = nil
        }
        
        return isValid
    }
    
    func login(email: String?, password: String?) {
        guard validate(email: email, password: password) else { return }
        
        onLoadingStateChanged?(true)
        
        let params: [String: Any] = [
            "email": email ?? "",
            "password": password ?? ""
        ]
        
        authService.login(parameters: params) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)
            
            switch result {
            case .success(let model):
                if model.success {
                    Utility.userToken = model.token ?? ""
                    self.onLoginSuccess?()
                } else {
                    self.onShowError?("Invalid credentials")
                }
            case .failure(let error):
                self.onShowError?(error.localizedDescription)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
