//
//  RefreshTokenStore.swift
//  loginsystem
//
//  Created by prchou on 2025/8/10.
//

import Vapor
import JWT
import FluentKit

protocol RefreshTokenRepository {
    
    func save(payload: RefreshTokenPayload, revoke: Bool, database: any Database) async throws
    
    func revoke(userID: String, database: any Database) async throws
    
    func findByToken(token: String, database: any Database) async throws -> RefreshTokenEntity?
    
    func validateToken(token: String, with deviceID: String, database: any Database) async throws -> Bool
    
    func deleteExpiredToken(database: any Database) async throws
    
}
