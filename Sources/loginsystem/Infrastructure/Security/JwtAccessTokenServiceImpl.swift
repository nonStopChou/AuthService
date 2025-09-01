//
//  JwtService.swift
//  loginsystem
//
//  Created by prchou on 2025/8/9.
//

import Vapor
import JWT
import JWTKit

final class JwtAccessTokenServiceImpl: JwtAccessTokenService, @unchecked Sendable {

    private let signer: JWTSigner
    private let config: JWTConfig
    
    init(app: Application) {
        self.config = app.jwtConfig
        self.signer = JWTSigner.hs256(key: Data(app.jwtConfig.signingKey.utf8))
    }
    

    func issueAccessToken(userID: String, provider: Provider, providerID: String) throws -> String {
        let claims = AccessTokenPayload(
            userID: userID,
            provider: provider,
            providerID: providerID,
            issuer: config.issuer,
            audience: config.audience,
            expirationTime: Double(config.accessExpiry)
        )
        return try signer.sign(claims)
    }
    
    func verifyAccessToken(_ token: String) throws -> AccessTokenPayload {
        do {
            let claims = try signer.verify(token, as: AccessTokenPayload.self)
            return claims
        } catch {
            throw DomainError.validationFailedError
        }
    }
    
}


extension Application {
    var jwtService: any JwtAccessTokenService {
        get {self.storage[JWTServiceKey.self]!}
        set {self.storage[JWTServiceKey.self] = newValue}
    }
    
    private struct JWTServiceKey: StorageKey {
        typealias Value = JwtAccessTokenService
    }
    
}
