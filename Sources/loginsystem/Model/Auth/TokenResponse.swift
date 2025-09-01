//
//  TokenResponse.swift
//  hello
//
//  Created by prchou on 2025/8/9.
//

import Vapor

struct TokenResponse: Content {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
