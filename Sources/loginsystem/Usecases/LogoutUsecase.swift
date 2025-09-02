//
//  LogoutUsecase.swift
//  loginsystem
//
//  Created by prchou on 2025/9/2.
//

import FluentKit

struct LogoutInput {
        
    let accessToken: String
}

struct LogoutOutput {
    
    let message: String
    
}


protocol LogoutUsecase {
    
    func execute(input: LogoutInput, database: any Database) async throws -> LogoutOutput
}
