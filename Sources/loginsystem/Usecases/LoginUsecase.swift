//
//  LoginUsecase.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//

import Vapor
import FluentKit


struct LoginUsecaseInput: Sendable {
    
    let authPricipal : AuthPrincipal
    let deviceID: String
    
    init(authPricipal: AuthPrincipal, deviceID: String) {
        self.authPricipal = authPricipal
        self.deviceID = deviceID
    }
}


struct LoginUsecaseOutput {
    let code: String
    
    init(code: String) {
        self.code = code
    }
}



protocol LoginUsecase {
    
    func execute(_ input: LoginUsecaseInput, database: any Database) async throws -> LoginUsecaseOutput
    
}


