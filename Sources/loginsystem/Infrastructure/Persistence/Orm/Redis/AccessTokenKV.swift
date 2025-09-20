//
//  AccessTokenKV.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Foundation

struct AccessTokenKV : Redisable {
    
    let sub: String
    let jti: String
    let refreshJti: String
    let tokenType: String
    let exp: Date

    init(sub: String, jti: String, refreshJti: String, tokenType: String, exp: Date) {
        self.sub = sub
        self.jti = jti
        self.refreshJti = refreshJti
        self.tokenType = tokenType
        self.exp = exp
    }
    
    func toKey() -> String {
        return "access_token:\(self.jti)"
    }
    
    func expiredAt() -> Date {
        return self.exp
    }
    
    
}

extension AccessTokenKV {
    
    static func toKey(jti: String) -> String {
        return "access_token:\(jti)"
    }
    
}
