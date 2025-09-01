//
//  UserMapper.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//

import Vapor

struct DomainMapper {
    static func toDomain(user: UserEntity) -> UserProfile {
        return UserProfile(
            id: user.id ?? UUID().uuidString,
            email: user.email,
            username: user.username,
            provider: Provider.from(user.provider),
            providerID: user.providerID,
            avatarURL: user.avatarURL,
            lastLoginDate: user.updateAt ?? Date()
        )
    }
    
}
