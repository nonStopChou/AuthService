//
//  AuthCodeKV.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Foundation

struct AuthCodeKV : Redisable {
    
    let sub: String
    let jti: String
    let deviceID: String
    let tokenType: String
    let exp: Date

    init(sub: String, jti: String, tokenType: String, deviceID: String, exp: Date) {
        self.sub = sub
        self.jti = jti
        self.deviceID = deviceID
        self.tokenType = tokenType
        self.exp = exp
    }
    
    func toKey() -> String {
        return "auth_code:\(self.jti)"
    }
    
    func expiredAt() -> Date {
        return self.exp
    }

    
}


extension AuthCodeKV {
    
    static func toKey(jti: String) -> String {
        return "auth_code:\(jti)"
    }
    
}
