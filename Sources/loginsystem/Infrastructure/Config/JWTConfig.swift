//
//  JWTConfig.swift
//  loginsystem
//
//  Created by prchou on 2025/8/15.
//

import Vapor

struct JWTConfig {
    let issuer: String
    let audience: String
    let accessExpiry: Double
    let signingKey: String
}

struct RefreshTokenConfig {
    let issuer: String
    let audience: String
    let refreshExpiry: Double
}


extension Application {
    var jwtConfig: JWTConfig {
        .init(
            issuer: Environment.get("JWT_ISSUER") ?? "LoginService",
            audience: Environment.get("JWT_AUDIENCE") ?? "",
            accessExpiry: Double(Environment.get("JWT_ACCESS_EXPIRY") ?? "3600") ?? 3600,
            signingKey: Environment.get("JWT_SIGNIN_KEY") ?? "default-signin-key"
        )
    }
    
    var refreshTokenConfig: RefreshTokenConfig {
        .init(
            issuer: jwtConfig.issuer,
            audience: jwtConfig.audience,
            refreshExpiry: Double(Environment.get("JWT_REFRESH_EXPIRY") ?? "604800") ?? 604800
        )
    }
}
