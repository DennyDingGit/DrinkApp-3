//
//  Login.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import Foundation


struct LoginRegisterBody: Encodable {
    let user: UserBody
}

struct UserBody: Encodable {
    let login: String
    let password: String
    var email: String?
}

struct LoginRegisterResponse: Decodable {
    let token: String
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case token = "User-Token"
        case login
    }
}
