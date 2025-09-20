//
//  UserRepository.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

import FluentKit
import Vapor

struct UserQueryRepositoryImpl : UserQueryRepository {
    
    func findUser(userID: String, on database: any Database) async throws -> UserEntity? {
        return try await UserEntity.query(on: database)
            .filter(\.$id == userID)
            .first()
    }
    
    func findUser(_ provider: String, _ providerID: String, on database: any Database) async throws -> UserEntity? {
        return try await UserEntity.query(on: database)
            .filter(\.$providerID == providerID)
            .filter(\.$provider == provider)
            .first()
    }
    
    func login(user: UserEntity, on database: any FluentKit.Database) async throws {
        user.updateAt = Date()
        try await user.update(on: database)
    }
    
}


extension Application {
    
    var userQueryRepository : any UserQueryRepository {
        UserQueryRepositoryImpl()
    }
    
}
