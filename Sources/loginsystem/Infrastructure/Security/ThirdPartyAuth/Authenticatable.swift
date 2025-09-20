//
//  AuthenticationService.swift
//  loginsystem
//
//  Created by prchou on 2025/8/26.
//
import  Vapor

protocol ThirdPartyAuthenticatable {
    
    var provider: String { get }
    
    var config: any AuthConfig { get }
    
    func fetchAuthURL(deviceID: String, appScheme: String) -> String
    
    func fetchUserProfile(code: String) async throws -> AuthPrincipal
    
}

protocol OAuthResponseProtocol : Decodable {
    
    var accessToken : String { get }
}

protocol OAuthUserProfileProtocol : Decodable {
    
    var id : String { get }
    var username : String { get }
    var email : String { get }
    var avatarURL: String { get }
    
}


extension ThirdPartyAuthenticatable {
    
    
    func fetchAuthURL(baseURL: String, deviceID: String, appScheme: String) -> String {
        let rawState = "deviceID=\(deviceID)&appScheme=\(appScheme)"
        let encodedState = rawState.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? rawState
        let authURL = baseURL
            .replacingOccurrences(of: "{clientID}", with: config.clientID)
            .replacingOccurrences(of: "{redirectURL}", with: config.redirectURL)
            .replacingOccurrences(of: "{state}", with: encodedState)
        return authURL
        
    }
    
    
    func fetchUserProfile<T: OAuthResponseProtocol, U: OAuthUserProfileProtocol>(
        code: String,
        response: T.Type,
        userProfile: U.Type
    ) async throws -> AuthPrincipal {
        
        // Token Endpoint
        let tokenURL = URL(string: config.tokenURL)!
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "code": code,
            "client_id": config.clientID,
            "client_secret": config.clientSecret,
            "redirect_uri": config.redirectURL,
            "grant_type": "authorization_code"
        ]
        
        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        // 呼叫 Token API
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print(String(data: data, encoding: .utf8) ?? "No response")

        let tokenResponse = try JSONDecoder().decode(response, from: data)
        
        // 呼叫 UserInfo API
        let userInfoURL = URL(string: config.userProfileURL)!
        var userReq = URLRequest(url: userInfoURL)
        userReq.setValue("Bearer \(tokenResponse.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (userData, _) = try await URLSession.shared.data(for: userReq)
        
        let user = try JSONDecoder().decode(userProfile, from: userData)
        
        // 包裝成你的領域模型 AuthPrincipal
        return AuthPrincipal(
            username: user.username,
            email: user.email,
            provider: Provider.from(provider),
            providerID: user.id,
            avatarURL: user.avatarURL
        )
    }
    
    
    
}
