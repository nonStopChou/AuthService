//
//  UserCrudRepository.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

import FluentKit
import Vapor

struct UserCrudRepositoryImpl : UserCrudRepository {
    
    func createUser(email: String, username: String, provider: String, providerID: String, avatarURL:String?, database: any Database) async throws -> UserEntity {
        
        let newUser: UserEntity = UserEntity(
            email: email,
            username: username,
            provider: provider,
            providerID: providerID,
            avatarURL: avatarURL ?? ""
        )
        
        try await newUser.save(on: database)
        
        return newUser
    }
    
}

extension Application {
    
    var userCrudRepository : any UserCrudRepository {
        UserCrudRepositoryImpl()
    }
    
}
