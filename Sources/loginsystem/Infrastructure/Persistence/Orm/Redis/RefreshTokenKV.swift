//
//  RefreshTokenKV.swift
//  loginsystem
//
//  Created by prchou on 2025/9/12.
//
import Vapor
import Redis
import NIOCore // for ByteBuffer

struct RefreshTokenKV: Redisable {
    
    let sub: String
    let jti: String
    let deviceID: String
    let tokenType: String
    let exp: Date
    
    init(sub: String, jti: String, deviceID: String, tokenType: String, exp: Date) {
        self.sub = sub
        self.jti = jti
        self.deviceID = deviceID
        self.tokenType = tokenType
        self.exp = exp
    }
    
    func toKey() -> String {
            return "refresh_token:\(jti)"
    }
    
    func expiredAt() -> Date {
        return self.exp
    }
    
}


extension RefreshTokenKV {
    
    static func toKey(jti: String) -> String {
        return "refresh_token:\(jti)"
    }
    
}
