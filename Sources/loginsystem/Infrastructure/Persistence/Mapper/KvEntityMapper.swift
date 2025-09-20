//
//  KvEntityMapper.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//

class KvEntityMapper {
    
    static func toKvEntity(domain: AuthCode) -> AuthCodeKV {
        return AuthCodeKV(sub: domain.sub, jti: domain.jti,tokenType: domain.tokenType, deviceID: domain.deviceID, exp: domain.exp)
    }
    
    static func toKvEntity(domain: AccessToken, refreshJti: String) -> AccessTokenKV {
        return AccessTokenKV(sub: domain.sub, jti: domain.jti, refreshJti: refreshJti, tokenType: domain.tokenType, exp: domain.exp)
    }
    
    static func toKvEntity(domain: RefreshToken) -> RefreshTokenKV {
        return RefreshTokenKV(sub: domain.sub, jti: domain.jti, deviceID: domain.deviceID, tokenType: domain.tokenType, exp: domain.exp)
    }
    
    static func toSessionKvEntity(domain: RefreshToken) -> SessionKV {
        return SessionKV(sub: domain.sub, refreshJti: domain.jti, deviceID: domain.deviceID, exp: domain.exp)
    }
    
}
