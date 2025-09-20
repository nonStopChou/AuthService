//
//  Google+Authenticatable.swift
//  loginsystem
//
//  Created by prchou on 2025/8/26.
//

import Vapor

struct GoogleAuth: ThirdPartyAuthenticatable {
    
    
    var provider: String
    var config: any AuthConfig
    
    private let baseURL = "https://accounts.google.com/o/oauth2/v2/auth?client_id={clientID}&redirect_uri={redirectURL}&response_type=code&scope=openid%20email%20profile&access_type=offline&state={state}"
    
    init(app: Application) {
        self.provider = "google"
        self.config = app.googleConfig
    }
    
    func fetchAuthURL(deviceID: String, appScheme: String) -> String {
        return fetchAuthURL(baseURL: baseURL, deviceID: deviceID, appScheme: appScheme)
    }
    
    
    func fetchUserProfile(code: String) async throws -> AuthPrincipal {
        return try await fetchUserProfile(code: code, response: GoogleResponse.self, userProfile: GoogleUser.self)
    }
    
    
}

struct GoogleResponse : OAuthResponseProtocol {
    let access_token: String
    
    var accessToken: String { access_token }
    
    enum CodingKeys: String, CodingKey {
        case access_token
    }
}


struct GoogleUser: OAuthUserProfileProtocol {
    
    var avatarURL: String {picture}
    var email: String
    var id: String {sub}
    var username: String {name}
    let sub: String
    let name: String
    let picture: String
    
}


struct GoogleConfig : AuthConfig {
    
    let clientID: String
    let clientSecret: String
    let redirectURL: String
    let tokenURL: String
    let userProfileURL: String
}


