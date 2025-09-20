//
//  UserController.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor
import FluentKit

struct UserController: RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let user = routes.grouped("user")
        user.get("me", use: getme)
        
    }
    
    
    func getme(req: Request) async throws -> Response {
        
        guard let bearer = req.headers.bearerAuthorization
        else {
            throw HttpError.headerNotFoundError(header: "Authorization")
        }
        
        let input = GetMeUsecaseInput(accessToken: bearer.token)
    
        let output: GetMeUsecaseOutput = try await req.application.getMeUsecase.execute(input: input, database: req.db)
        
        let userProfile: UserProfile = output.userProfile
        
        let response: GetMeOutputDto = GetMeOutputDto(email: userProfile.email, username: userProfile.username, loginWith: userProfile.provider.rawValue, avatarURL: userProfile.avatarURL)
        
        return try await response.encodeResponse(for: req)
    }
        
}
