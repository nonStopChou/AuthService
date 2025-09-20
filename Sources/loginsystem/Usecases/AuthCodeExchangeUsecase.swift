//
//  AuthCodeExchangeUsecase.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//

import FluentKit

protocol AuthCodeExchangeUsecase {
    
    func execute(input: AuthCodeExchangeUsecaseInput, database: any Database) async throws -> AuthCodeExchangeUsecaseOutput

    
}

struct AuthCodeExchangeUsecaseInput {
    let authCode: String
}

struct AuthCodeExchangeUsecaseOutput {
    let userProfile: UserProfile
    let accessToken: String
    let refreshToken: String
}
