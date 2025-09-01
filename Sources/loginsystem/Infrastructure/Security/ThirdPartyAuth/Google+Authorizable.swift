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
    
    private let baseURL =
                            """
                                https://accounts.google.com/o/oauth2/v2/auth
                                ?client_id={clientID}
                                &redirect_uri={redirectURL}
                                &response_type=code
                                &scope=openid%20email%20profile
                                &access_type=offline
                                &state={deviceID}
                            """
    
    init(app: Application) {
        self.provider = "google"
        self.config = app.googleConfig
    }
    
    func fetchAuthURL(deviceID: String) -> String {
        
        let authURL = baseURL
            .replacingOccurrences(of: "{clientID}", with: config.clientID)
            .replacingOccurrences(of: "{redirectURL}", with: config.redirectURL)
            .replacingOccurrences(of: "{deviceID}", with: "deviceID=\(deviceID)")
        return authURL
        
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
    
    var avatarURL: String{
        picture
    }
    
    
    var email: String
    
    var id: String {
        sub
    }
    
    var username: String {
        name
    }
    
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
    
}
