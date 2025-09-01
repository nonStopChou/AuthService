//
//  Discord+Authenticatable.swift
//  loginsystem
//
//  Created by prchou on 2025/8/27.
//

import Vapor

struct DiscordAuth : ThirdPartyAuthenticatable {
    
    var provider: String
    var config: any AuthConfig
    
    private let baseURL = """
        https://discord.com/api/oauth2/authorize
        ?client_id={clientID}
        &redirect_uri={redirectURL}
        &response_type=code
        &scope=identify%20email
        &state={deviceID}
        """
        
    init(app: Application) {
        self.provider = "discord"
        self.config = app.discordConfig
    }
    
    
    func fetchAuthURL(deviceID: String) -> String {
        
        let authURL = baseURL
            .replacingOccurrences(of: "{clientID}", with: config.clientID)
            .replacingOccurrences(of: "{redirectURL}", with: config.redirectURL)
            .replacingOccurrences(of: "{deviceID}", with: "deviceID=\(deviceID)")
        return authURL
        
    }
    
    func fetchUserProfile(code: String) async throws -> AuthPrincipal {
        return try await fetchUserProfile(code: code, response: DiscordResponse.self, userProfile: DiscordUser.self)
    }
    
    
}

struct DiscordResponse : OAuthResponseProtocol {
    let access_token: String
    
    var accessToken: String { access_token }
    
    enum CodingKeys: String, CodingKey {
        case access_token
    }
}

struct DiscordUser : OAuthUserProfileProtocol {
    var id: String
    var username: String
    var email: String
    let avatar: String
    var avatarURL: String {
        "https://cdn.discordapp.com/avatars/\(id)/\(avatar).png"
    }
    
}



struct DiscordConfig : AuthConfig {
  
    let clientID: String
    let clientSecret: String
    let redirectURL: String
    let tokenURL: String
    let userProfileURL: String
    
}


extension Application {
    
    var discordConfig: DiscordConfig {
        .init(
            clientID: Environment.get("DISCORD_CLIENT_ID") ?? "",
            clientSecret: Environment.get("DISCORD_CLIENT_SECRET") ?? "",
            redirectURL: Environment.get("DISCORD_REDIRECT_URL") ?? "",
            tokenURL: Environment.get("DISCORD_TOKEN_URL") ?? "",
            userProfileURL: Environment.get("DISCORD_USER_PROFILE_URL") ?? "https://discord.com/api/users/@me"
        )
    }
    
}
