//
//  AuthenticationController.swift
//  loginsystem
//
//  Created by prchou on 2025/8/24.
//

import Vapor

struct AuthController : RouteCollection{
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let auth = routes.grouped("login")
        
        auth.post(":provider", "url", use: authURL)
        
        auth.get(":provider", "profile", use: login)
        
    }
    
    func authURL(req: Request) async throws -> Response {
        
        let dto : GetAuthUrlDto = try req.content.decode(GetAuthUrlDto.self)
        
        let deviceID = dto.deviceID
        
        guard let provider = req.parameters.get("provider") else {
            throw Abort(.badRequest, reason: "Missing provider")
        }
        
            
        let authenticator = try AuthFactory.makeAuth(provider: provider, app: req.application)
        let url = authenticator.fetchAuthURL(deviceID: deviceID)
        
        return Response(status: .ok, body: .init(string: url))
    }
    
    func login(req: Request) async throws -> Response {
    
        guard let provider = req.parameters.get("provider") else {
            throw Abort(.badRequest, reason: "Missing provider")
        }
        
        guard let code : String = req.query["code"] else {
            throw Abort(.badRequest, reason: "Missing code")
        }
        
        guard let state : String = req.query["state"] else {
            throw Abort(.badRequest, reason: "Missing state")
        }
        
        let components = state.split(separator: "=")
        guard components.count == 2, components[0] == "deviceID" else {
            throw Abort(.badRequest, reason: "Invalid state format")
        }
        let deviceId = String(components[1])
    
        
        let authenticator = try AuthFactory.makeAuth(provider: provider, app: req.application)
        let authPrincipal : AuthPrincipal = try await authenticator.fetchUserProfile(code: code)
        
    
        let loginUserInput : LoginInput = LoginInput(authPricipal: authPrincipal, deviceID: deviceId)
        
        let loginUserOutput: LoginOutput = try await req.application.userLoginUsecase.execute(loginUserInput, database: req.db)
        
        let loginUserViewModel: LoginViewModel = req.application.loginPresenter.present(loginUserOutput)
        
        return try await loginUserViewModel.encodeResponse(for: req)
    }
    
}

