//
//  UserCrudRepository.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

import FluentKit

protocol UserCrudRepository {
    
    func createUser(email: String, username: String, provider: String, providerID: String, avatarURL:String?, database: any Database) async throws -> UserEntity
    
}
