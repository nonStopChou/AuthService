//
//  Visitor+Authorizable.swift
//  loginsystem
//
//  Created by prchou on 2025/9/13.
//
import Foundation
import Vapor

struct VisitorAuth : ThirdPartyAuthenticatable {
    
    
    private let baseURL = "http://localhost:8080/login/visitor/profile?client_id={clientID}&redirect_uri={redirectURL}&response_type=code&scope=openid%20email%20profile&access_type=offline&state={state}"
    
    
    init(app: Application) {
        self.provider = "visitor"
        self.config = app.visitorConfig
    }
    
    
    func fetchUserProfile(code: String) async throws -> AuthPrincipal {
        
        return AuthPrincipal(
            username: UUID().uuidString,
            email: "visitor@email.com",
            provider: Provider.from("visitor"),
            providerID: UUID().uuidString,
            avatarURL: ""
        )
        
    }
    
    func fetchAuthURL(deviceID: String, appScheme: String) -> String {
        return fetchAuthURL(baseURL: baseURL, deviceID: deviceID, appScheme: appScheme)
    }
    
    
    var provider: String
    
    var config: any AuthConfig
    
    
}


struct VisitorConfig : AuthConfig {
    
    let clientID: String
    let clientSecret: String
    let redirectURL: String
    let tokenURL: String
    let userProfileURL: String
}


