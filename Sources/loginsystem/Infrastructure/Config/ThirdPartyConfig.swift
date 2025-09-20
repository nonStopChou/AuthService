//
//  ThirdPartyConfig.swift
//  loginsystem
//
//  Created by prchou on 2025/9/13.
//
import Vapor

extension Application {
    
    var googleConfig: GoogleConfig {
        .init(
            clientID: Environment.get("GOOGLE_CLIENT_ID") ?? "",
            clientSecret: Environment.get("GOOGLE_CLIENT_SECRET") ?? "",
            redirectURL: Environment.get("GOOGLE_REDIRECT_URL") ?? "",
            tokenURL: Environment.get("GOOGLE_TOKEN_URL") ?? "",
            userProfileURL: Environment.get("GOOGLE_USER_PROFILE_URL") ?? "https://www.googleapis.com/oauth2/v3/userinfo"
           
        )
    }
    
    
    var discordConfig: DiscordConfig {
        .init(
            clientID: Environment.get("DISCORD_CLIENT_ID") ?? "",
            clientSecret: Environment.get("DISCORD_CLIENT_SECRET") ?? "",
            redirectURL: Environment.get("DISCORD_REDIRECT_URL") ?? "",
            tokenURL: Environment.get("DISCORD_TOKEN_URL") ?? "",
            userProfileURL: Environment.get("DISCORD_USER_PROFILE_URL") ?? "https://discord.com/api/users/@me"
        )
    }
    
    var visitorConfig: VisitorConfig {
        .init(
            clientID: "visitor",
            clientSecret: "visitor",
            redirectURL: "",
            tokenURL: "",
            userProfileURL: ""
        )
    }
    
}
