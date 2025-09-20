//
//  LogoutUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/2.
//

import Vapor
import FluentKit

struct LogoutUsecaseImpl : LogoutUsecase {
    
    let tokenService: any TokenService
    
    func execute(input: LogoutInput, database: any Database) async throws -> LogoutOutput {
            
        let refreshTokenPayload = try tokenService.verifyRefreshToken(refreshToken: input.refreshToken)
        
        try await tokenService.logout(userID: refreshTokenPayload.getUserID())
        
        return LogoutOutput(message: "Logout Success.")
    }
    
}


extension Application {
    
    var userLogoutUsecase : any LogoutUsecase {
        LogoutUsecaseImpl(
            tokenService: self.tokenService
        )
    }
    
}
