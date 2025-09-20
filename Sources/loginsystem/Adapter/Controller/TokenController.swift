//
//  TokenController.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//

import Vapor

struct TokenController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let code = routes.grouped("code")
        code.get("who", "am", "i", ":code", use: codeExchange)
        
        let token = routes.grouped("token")
        token.post("refresh", use: refreshToken)
        
    }
    
    func refreshToken(_ req: Request) async throws -> Response {
        guard let authHeader = req.headers.bearerAuthorization
        else {
            throw HttpError.headerNotFoundError(header: "Authorization")
        }
        
        let deviceID: String = try req.content.get(at: "deviceID")
        
        let output: RefreshOutput = try await req.application.refreshTokenUsecase.execute(token: authHeader.token, deviceID: deviceID)
        
        let response: RefreshTokenOutputDto = RefreshTokenOutputDto(accessToken: output.accessToken, refreshToken: output.refreshToken)
        
        return try await response.encodeResponse(for: req)
    }
    
    
    func codeExchange(_ req: Request) async throws -> Response {
        
        guard let code = req.parameters.get("code") else {
            throw Abort(.badRequest, reason: "Missing code")
        }
        print("Code : \(code)")
        
        let output: AuthCodeExchangeUsecaseOutput = try await req.application.authCodeExchangeUsercase.execute(input: AuthCodeExchangeUsecaseInput(authCode: code), database: req.db)
        
        let userProfile = output.userProfile
        
        let response: AuthCodeExchangeOutputDto = AuthCodeExchangeOutputDto(email: userProfile.email, username: userProfile.username, loginWith: userProfile.provider.rawValue, avatarURL: userProfile.avatarURL, accessToken: output.accessToken, refreshToken: output.refreshToken)
        
        return try await response.encodeResponse(for: req)
    }
}
