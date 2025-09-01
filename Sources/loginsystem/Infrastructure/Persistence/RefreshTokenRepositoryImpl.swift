//
//  RefreshTokenRepository.swift
//  loginsystem
//
//  Created by prchou on 2025/8/10.
//
import FluentKit
import Vapor

struct RefreshTokenRepositoryImpl : RefreshTokenRepository {

    let logger = Logger(label: "RefreshTokenRepositoryImpl")
    
    func save(payload: RefreshTokenPayload, revoke: Bool = false, database: any Database) async throws {
        
        let token = payload.jti.value
        let userID = payload.userID
        let deviceID = payload.deviceID
        let expiredAt = payload.exp.value
        
        try await database.transaction { transaction in
            
            try await RefreshTokenEntity.query(on: transaction)
                .filter(\RefreshTokenEntity.$userID == userID)
                .delete()
            
            let newRefreshTokenEntities = RefreshTokenEntity(
                token: token,
                userID: userID,
                deviceID: deviceID,
                expiresAt: expiredAt,
                revoked: revoke
            )
            
            try await newRefreshTokenEntities.save(on: transaction)
        }
        
    }
    
    
    func revoke(token: String, database: any Database) async throws {
        try await RefreshTokenEntity.query(on: database)
            .filter(\RefreshTokenEntity.$token == token)
            .set(\.$revoked, to: true)
            .update()
    }
    
    func findByToken(token: String, database: any Database) async throws -> RefreshTokenEntity? {
        return try await RefreshTokenEntity.query(on: database)
            .filter(\RefreshTokenEntity.$token == token)
            .first()
    }
    
    func validateToken(token: String, with deviceID: String, database: any Database) async throws -> Bool {
        guard let record: RefreshTokenEntity = try await self.findByToken(token: token, database: database)
        else {
            return false
        }
        
        return record.expiresAt >= Date() && record.revoked == false && record.deviceID == deviceID
    }
    
    func deleteExpiredToken(database: any Database) async throws {
        try await RefreshTokenEntity.query(on: database)
            .filter(\RefreshTokenEntity.$expiresAt < Date())
            .delete()
    }
    
}
