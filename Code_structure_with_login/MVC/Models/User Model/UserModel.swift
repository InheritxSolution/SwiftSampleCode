//
//  UserModel.swift
//  Inheritx Solutions
//

import Foundation

struct UserModel: Codable {
    let success: Bool
    let token: String?
    let data: UserData?
    
    enum CodingKeys: String, CodingKey {
        case success
        case token
        case data
    }
}

struct UserData: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

