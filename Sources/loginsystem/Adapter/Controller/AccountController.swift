//
//  AuthenticationController.swift
//  loginsystem
//
//  Created by prchou on 2025/8/24.
//

import Vapor

struct AccountController : RouteCollection{
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let auth = routes.grouped("login")
        
        auth.post(":provider", "url", use: authURL)
        
        auth.get(":provider", "profile", use: login)
        
        let account = routes.grouped("account")
        
        account.post("logout", use: logout)
        
        
    }
    
    func authURL(req: Request) async throws -> Response {
        
        let dto : GetAuthUrlDto = try req.content.decode(GetAuthUrlDto.self)
        
        guard let provider = req.parameters.get("provider") else {
            throw Abort(.badRequest, reason: "Missing provider")
        }
        
        let deviceID = dto.deviceID
        
        let appScheme = dto.appScheme
            
        let authenticator = try AuthFactory.makeAuth(provider: provider, app: req.application)
        let url = authenticator.fetchAuthURL(deviceID: deviceID, appScheme: appScheme)
        
        struct FetchAuthURLDTO: Content { let authURL: String }
        print("Fetch Auth URl : " + url)
        let fetchAuthUrl = FetchAuthURLDTO(authURL : url)
        return try await fetchAuthUrl.encodeResponse(for: req)
    }
    
    func login(req: Request) async throws -> Response {
        guard let provider = req.parameters.get("provider") else {
            throw Abort(.badRequest, reason: "Missing provider")
        }
        
        guard let state : String = req.query["state"] else {
            throw Abort(.badRequest, reason: "Missing state")
        }
        
        // 2. URL decode
        guard let decoded = state.removingPercentEncoding else {
            throw Abort(.badRequest, reason: "Invalid state encoding")
        }
        print(decoded)
        // 3. 拆成 dictionary
        let components = decoded.split(separator: "&")
        var stateDict: [String: String] = [:]
        
        for component in components {
            let pair = component.split(separator: "=", maxSplits: 1)
            if pair.count == 2 {
                let key = String(pair[0])
                let value = String(pair[1])
                stateDict[key] = value
            }
        }
        
        // 4. 取出 deviceID 和 appScheme
        guard let deviceId = stateDict["deviceID"],
              let appScheme = stateDict["appScheme"] else {
            throw Abort(.badRequest, reason: "Missing deviceID or appScheme in state")
        }
        
        let authenticator = try AuthFactory.makeAuth(provider: provider, app: req.application)
        var authPrincipal :  AuthPrincipal
        
        if(provider == "visitor") {
            authPrincipal = try await authenticator.fetchUserProfile(code: "")
        } else {
            guard let code : String = req.query["code"] else {
                throw Abort(.badRequest, reason: "Missing code")
            }
            authPrincipal = try await authenticator.fetchUserProfile(code: code)
        }
        
        let loginUserInput : LoginUsecaseInput = LoginUsecaseInput(authPricipal: authPrincipal, deviceID: deviceId)
        
        let loginUserOutput: LoginUsecaseOutput = try await req.application.userLoginUsecase.execute(loginUserInput, database: req.db)
        
    
        let callbackUrl = "\(appScheme)://auth/callback?deviceId=\(deviceId)&code=\(loginUserOutput.code)"
        print("callbackUrl: \(callbackUrl)")
        return req.redirect(to: callbackUrl)
    }
    
    func logout(req: Request) async throws -> Response {
        
        let input : LogoutInputDto = try req.content.decode(LogoutInputDto.self)
        
        let logoutInput : LogoutInput = .init(refreshToken: input.refreshToken)
        
        let logoutOutput: LogoutOutput = try await req.application.userLogoutUsecase.execute(input: logoutInput, database: req.db)
        
        return try await LogoutOutputDto(message: logoutOutput.message).encodeResponse(for: req)
    }
    
}

