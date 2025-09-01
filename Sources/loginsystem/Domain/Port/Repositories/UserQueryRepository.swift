//
//  UserRepository.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

import FluentKit


protocol UserQueryRepository {
    
    func findUser(_ provider: String, _ providerID: String, on database: any Database) async throws -> UserEntity?
    
    func login(user: UserEntity, on database: any Database) async throws
    
}
