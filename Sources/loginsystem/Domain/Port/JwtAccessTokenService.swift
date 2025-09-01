//
//  JwtAccessTokenService.swift
//  loginsystem
//
//  Created by prchou on 2025/8/10.
//

import Vapor


protocol JwtAccessTokenService: Sendable {
    
    func issueAccessToken(userID: String, provider: Provider, providerID: String) throws -> String
    
    func verifyAccessToken(_ token: String) throws -> AccessTokenPayload
}

