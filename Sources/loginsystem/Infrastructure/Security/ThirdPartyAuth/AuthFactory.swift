//
//  AuthFactory.swift
//  loginsystem
//
//  Created by prchou on 2025/8/27.
//

import Vapor

struct AuthFactory {
    
    static func makeAuth(provider: String, app: Application) throws -> any ThirdPartyAuthenticatable {
        
        switch provider.lowercased() {
            case "google" : return GoogleAuth(app: app)
            case "discord" : return DiscordAuth(app: app)
            case "visitor" : return VisitorAuth(app: app)
            default: throw Abort(.badRequest, reason: "Unsupported provider: \(provider)")
        }
        
        
    }
    
}
