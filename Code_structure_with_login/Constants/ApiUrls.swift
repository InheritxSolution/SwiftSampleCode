//
//  ApiUrls.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import Foundation

let baseUrl = "https://google.com/api/"

enum APi{
    case register
    case login
    case forgot_password
    case get_token

    var url: URL{
        switch self {
        case .register:
            return URL(string: baseUrl + "register")!
        case .login:
            return URL(string: baseUrl + "login")!
        case .forgot_password:
            return URL(string: baseUrl + "forgot_password")!
          case .get_token:
              return URL(string: baseUrl + "get_token")!
      }
    }
}


