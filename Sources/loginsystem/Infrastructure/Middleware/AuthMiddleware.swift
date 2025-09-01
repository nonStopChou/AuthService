//
//  AuthMiddleware.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//
import Vapor

struct AuthMiddleware: AsyncMiddleware {
    
    let accessTokenService: any JwtAccessTokenService
    
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        guard let authHeader = request.headers.bearerAuthorization
        else {
            throw HttpError.headerNotFoundError(header: "Bearer")
        }
                
        let payload: AccessTokenPayload = try accessTokenService.verifyAccessToken(authHeader.token)
        
        request.auth.login(AuthSession(userID: payload.userID))
        
        return try await next.respond(to: request)
    }
    
    
}


struct AuthSession: Authenticatable {
    let userID: String
}
