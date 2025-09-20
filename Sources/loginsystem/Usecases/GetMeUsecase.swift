//
//  GetMeUsecase.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import FluentKit

protocol GetMeUsecase {
    
    func execute(input: GetMeUsecaseInput, database: any Database) async throws -> GetMeUsecaseOutput
    
}


struct GetMeUsecaseInput {
    let accessToken: String
}


struct GetMeUsecaseOutput {
    let userProfile: UserProfile
}
