//
//  RefreshTokenUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/8/31.
//
import Vapor
import FluentKit

struct RefreshTokenUsecaseImpl: RefreshTokenUsecase {
    
    let tokenService: any TokenService
    
    func execute(token: String, deviceID: String) async throws -> RefreshOutput {
        
        let oldRefreshTokenPayload = try tokenService.verifyRefreshToken(refreshToken: token)
        
        let newAccessTokenPayload = AccessTokenPayload.of(userID: oldRefreshTokenPayload.getUserID())
        let newRefreshTokenPayload = RefreshTokenPayload.of(userID: oldRefreshTokenPayload.getUserID(), deviceID: deviceID)
        
        let newAccessToken = DomainMapper.toDomain(payload: newAccessTokenPayload)
        let newRefreshToken = DomainMapper.toDomain(payload: newRefreshTokenPayload)
        
        try await tokenService.saveToken(kvEntity: KvEntityMapper.toKvEntity(domain: newAccessToken, refreshJti: newRefreshToken.jti))
        try await tokenService.saveToken(kvEntity: KvEntityMapper.toKvEntity(domain: newRefreshToken))
        try await tokenService.saveSession(kvEntity: KvEntityMapper.toSessionKvEntity(domain: newRefreshToken))
        
        let newAccessTokenStr: String = try tokenService.issueToken(payload: newAccessTokenPayload)
        let newRefreshTokenStr: String = try tokenService.issueToken(payload: newRefreshTokenPayload)
        
        return RefreshOutput(accessToken: newAccessTokenStr, refreshToken: newRefreshTokenStr)
    }
    
}


extension Application {
    
    var refreshTokenUsecase: any RefreshTokenUsecase {
        RefreshTokenUsecaseImpl(
            tokenService: self.tokenService
        )
    }
    
}
