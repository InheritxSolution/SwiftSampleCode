//
//  AuthenticationService.swift
//  Inheritx Solutions
//

import Foundation
import SwiftyJSON

protocol AuthenticationServiceProtocol {
    func login(parameters: [String: Any], completion: @escaping (Result<UserModel, Error>) -> Void)
}

class AuthenticationService: AuthenticationServiceProtocol {
    
    func login(parameters: [String: Any], completion: @escaping (Result<UserModel, Error>) -> Void) {
        var request = AlamofireRequestModal()
        request.method = .get // Based on original code's use of APi.register/getOrderDetails
        request.path = APi.register.url.absoluteString
        request.parameters = parameters
        
        AppLogger.shared.log("Initiating login request...", category: .network)
        
        APIManager.shared.callWebServiceAlamofire(request, success: { (json) in
            do {
                let data = try json.rawData()
                let userModel = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(userModel))
            } catch {
                AppLogger.shared.error("Decoding error: \(error.localizedDescription)", category: .network)
                completion(.failure(error))
            }
        }, failure: { (error) in
            AppLogger.shared.error("Network error: \(error?.localizedDescription ?? "Unknown")", category: .network)
            completion(.failure(error ?? NSError(domain: "AuthService", code: -1, userInfo: nil)))
        })
    }
}
