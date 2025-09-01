//
//  TokenController.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//

import Vapor

struct TokenController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let auth = routes.grouped("token")
        auth.post("refresh", use: refreshToken)
        
    }
    
    func refreshToken(_ req: Request) async throws -> Response {
        guard let authHeader = req.headers.bearerAuthorization
        else {
            throw HttpError.headerNotFoundError(header: "Authorization")
        }
        
        let deviceID: String = try req.content.get(at: "deviceID")
        
        let output: RefreshOutput = try await req.application.refreshTokenUsecase.execute(token: authHeader.token, deviceID: deviceID, database: req.db)
        
        let response: RefreshTokenOutputDto = RefreshTokenOutputDto(accessToken: output.accessToken, refreshToken: output.refreshToken)
        
        return try await response.encodeResponse(for: req)
    }
}
