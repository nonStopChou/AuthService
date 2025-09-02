//
//  LogoutUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/2.
//

import Vapor
import FluentKit

struct LogoutUsecaseImpl : LogoutUsecase {
    
    let jwtAccessTokenService: any JwtAccessTokenService
    let refreshTokenRepository: any RefreshTokenRepository
    
    func execute(input: LogoutInput, database: any Database) async throws -> LogoutOutput {
            
        let accessTokenPayLoad : AccessTokenPayload = try jwtAccessTokenService.verifyAccessToken(input.accessToken)
        
        let userID : String = accessTokenPayLoad.userID
        
        try await refreshTokenRepository.revoke(userID: userID, database: database)
        
        return LogoutOutput(message: "Logout Success.")
    }
    
}


extension Application {
    
    var userLogoutUsecase : any LogoutUsecase {
        LogoutUsecaseImpl(
            jwtAccessTokenService: self.jwtService,
            refreshTokenRepository: self.refreshTokenRepository
        )
    }
    
}
