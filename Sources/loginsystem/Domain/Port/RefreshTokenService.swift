//
//  RefreshTokenService.swift
//  loginsystem
//
//  Created by prchou on 2025/8/16.
//

import FluentKit

protocol RefreshTokenService: Sendable {
    
    func issueRefreshToken(userID: String, provider: Provider, providerID: String, with deviceID: String, database: any Database) async throws -> String
    
    func revokeRefreshToken(_ token: String, database: any Database) async throws
    
    func verifyRefreshToken(_ token: String,with deviceID: String, database: any Database) async throws -> RefreshTokenPayload
    
}
