//
//  TokenService.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//


import JWT
import Foundation
import Vapor

protocol TokenService: Sendable {
    
    func isKeyExist(key: String) async throws -> Bool
    
    func issueToken(payload: any JWTPayload) throws -> String
    
    func verifyAccessToken(accessToken: String) throws -> AccessTokenPayload
    
    func verifyRefreshToken(refreshToken: String) throws -> RefreshTokenPayload
    
    func verifyAuthCode(authCode: String) throws -> AuthCodeTokenPayload
    
    func saveToken(kvEntity: any Redisable) async throws
    
    func deleteAuthCode(kvEntity: AuthCodeKV) async throws
    
    func saveSession(kvEntity: SessionKV) async throws
    
    func logout(userID: String) async throws
    
    
}
