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
    
    static func toDomain(payload: AuthCodeTokenPayload) -> AuthCode {
        return AuthCode(sub: payload.getUserID(), jti: payload.jti.value, deviceID: payload.deviceID)
    }
    
    
    static func toDomain(payload: AccessTokenPayload) -> AccessToken {
        return AccessToken(sub: payload.getUserID(), jti: payload.jti.value)
    }
    
    
    static func toDomain(payload: RefreshTokenPayload) -> RefreshToken {
        return RefreshToken(sub: payload.getUserID(), jti: payload.jti.value, deviceID: payload.deviceID)
    }
    
}
