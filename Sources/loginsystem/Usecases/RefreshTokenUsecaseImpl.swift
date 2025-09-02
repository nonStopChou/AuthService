//
//  RefreshTokenUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/8/31.
//
import Vapor
import FluentKit

struct RefreshTokenUsecaseImpl: RefreshTokenUsecase {
    
    let jwtAccessTokenService: any JwtAccessTokenService
    let refreshTokenService: any RefreshTokenService
    
    func execute(token: String, deviceID: String, database: any Database) async throws -> RefreshOutput {
        
        let payload: RefreshTokenPayload = try await refreshTokenService.verifyRefreshToken(token, with: deviceID, database: database)
        
        let newAccessToken: String = try jwtAccessTokenService.issueAccessToken(userID: payload.userID, provider: payload.provider, providerID: payload.providerID)
        
        let newRefreshToken: String = try await refreshTokenService.issueRefreshToken(userID: payload.userID, provider: payload.provider, providerID: payload.providerID, with: payload.deviceID, database: database)
        
        return RefreshOutput(accessToken: newAccessToken, refreshToken: newRefreshToken)
    }
    
}


extension Application {
    
    var refreshTokenUsecase: any RefreshTokenUsecase {
        RefreshTokenUsecaseImpl(
            jwtAccessTokenService: self.jwtService,
            refreshTokenService: self.refreshTokenService
        )
    }
    
}
