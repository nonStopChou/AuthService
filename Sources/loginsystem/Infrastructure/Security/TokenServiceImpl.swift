//
//  TokenServiceImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//

import Vapor
import JWT
import Foundation
import Redis

final class TokenServiceImpl: TokenService, @unchecked Sendable  {

    private let signer: JWTSigner
    private let kvRepository: any KVRepository
    
    
    init(app: Application) {
        self.signer = JWTSigner.hs256(key: Data(app.jwtConfig.signingKey.utf8))
        self.kvRepository = app.kvRepository
    }
    
    
    func issueToken(payload: any JWTPayload) throws -> String {
        return try self.signer.sign(payload)
    }
    
    func verifyAccessToken(accessToken: String) throws -> AccessTokenPayload {
        do {
            let claims = try signer.verify(accessToken, as: AccessTokenPayload.self)
            return claims
        } catch {
            throw DomainError.validationFailedError
        }
    }
    
    func verifyRefreshToken(refreshToken: String) throws -> RefreshTokenPayload {
        do {
            let claims = try signer.verify(refreshToken, as: RefreshTokenPayload.self)
            return claims
        } catch {
            throw DomainError.validationFailedError
        }
    }
    
    func verifyAuthCode(authCode: String) throws -> AuthCodeTokenPayload {
        do {
            let claims = try signer.verify(authCode, as: AuthCodeTokenPayload.self)
            return claims
        } catch {
            throw DomainError.validationFailedError
        }
    }
    
    func saveToken(kvEntity: any Redisable) async throws {
        try await kvRepository.saveExpired(object: kvEntity)
    }
    
    func deleteAuthCode(kvEntity: AuthCodeKV) async throws {
        try await kvRepository.remove(key: kvEntity.toKey())
    }
    
    func saveSession(kvEntity: SessionKV) async throws {
        try await kvRepository.save(object: kvEntity)
    }
    
    func logout(userID: String) async throws {
        try await kvRepository.remove(key: userID)
    }
    
    func isKeyExist(key: String) async throws -> Bool {
        return try await kvRepository.contains(key: key)
    }
}


extension Application {
    
    var tokenService: any TokenService {
        get {self.storage[TokenKey.self]!}
        set {self.storage[TokenKey.self] = newValue}
    }
    
    private struct TokenKey: StorageKey {
        typealias Value = TokenService
    }
    
}
