//
//  RefreshTokenService.swift
//  loginsystem
//
//  Created by prchou on 2025/8/10.
//

import Vapor
import JWTKit
import JWT
import FluentKit


final class RefreshTokenServiceImpl : RefreshTokenService, @unchecked Sendable {
   
    let logger = Logger(label: "RefreshTokenServiceImpl")
    
    private let signer: JWTSigner
    private let config: RefreshTokenConfig
    private let store: any RefreshTokenRepository = RefreshTokenRepositoryImpl()
    
    init(app: Application) {
        self.signer = JWTSigner.hs256(key: Data(app.jwtConfig.signingKey.utf8))
        self.config = app.refreshTokenConfig
    }
    

    func issueRefreshToken(userID: String, provider: Provider, providerID: String, with deviceID: String, database: any Database) async throws -> String {
        
        let tokenID: String = UUID().uuidString
        
        let payload = RefreshTokenPayload(
            jti: tokenID,
            userID: userID,
            provider: provider,
            providerID: providerID,
            deviceID: deviceID,
            issuer: config.issuer,
            audience: config.audience,
            expirationTime: Double(config.refreshExpiry)
        )
        
        let token = try signer.sign(payload)

        try await store.save(payload: payload, revoke: false ,database: database)
        
        return token
    }
    
    func verifyRefreshToken(_ token: String, with deviceID: String, database: any Database) async throws -> RefreshTokenPayload {
        let claims = try signer.verify(token, as: RefreshTokenPayload.self)
        
        guard claims.iss.value == config.issuer, claims.aud.value.contains(config.audience) else {
            throw DomainError.validationFailedError
        }
        logger.info("TokenID : \(claims.jti.value)\n, UserID: \(claims.userID)\n, deviceID: \(claims.deviceID)\n, issuer: \(claims.iss.value)\n, audience: \(claims.aud.value)\n")
        
        let tokenID: String = claims.jti.value
        
        let isValid: Bool = try await store.validateToken(token: tokenID, with: claims.deviceID, database: database)
        
        if(!isValid) {
            throw DomainError.validationFailedError
        }
        return claims
    }
    
    func revokeRefreshToken(_ token: String, database: any Database) async throws {
        let claims = try signer.verify(token, as: RefreshTokenPayload.self)
        try await store.revoke(token: claims.jti.value, database: database)
    }
    
    
}


extension Application {
    
    var refreshTokenService: any RefreshTokenService {
        get {self.storage[RefreshTokenKey.self]!}
        set {self.storage[RefreshTokenKey.self] = newValue}
    }
    
        private struct RefreshTokenKey: StorageKey {
            typealias Value = RefreshTokenService
        }
    
}
