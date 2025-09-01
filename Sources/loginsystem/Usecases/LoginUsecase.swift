//
//  LoginUsecase.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//

import Vapor
import FluentKit


struct LoginInput: Sendable {
    
    let authPricipal : AuthPrincipal
    let deviceID: String
    
    init(authPricipal: AuthPrincipal, deviceID: String) {
        self.authPricipal = authPricipal
        self.deviceID = deviceID
    }
}


struct LoginOutput {
    let userProfile: UserProfile
    let accessToken: String
    let refreshToken: String
    
    init(userProfile: UserProfile, accessToken: String, refreshToken: String) {
        self.userProfile = userProfile
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}



protocol LoginUsecase {
    
    func execute(_ input: LoginInput, database: any Database) async throws -> LoginOutput
    
}


