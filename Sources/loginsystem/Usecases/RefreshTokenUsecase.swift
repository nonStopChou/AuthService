//
//  RefreshUsecase.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//

import Vapor
import FluentKit


struct RefreshOutput {
    
    let accessToken: String
    let refreshToken: String
    
}


protocol RefreshTokenUsecase {
    
    func execute(token: String, deviceID: String) async throws -> RefreshOutput
    
}

