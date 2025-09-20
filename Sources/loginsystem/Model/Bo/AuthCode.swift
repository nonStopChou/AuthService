//
//  AuthCode.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Foundation

struct AuthCode {
    
    let sub: String
    let jti: String
    let deviceID: String
    let tokenType: String
    let exp: Date

    init(sub: String, jti: String, deviceID: String) {
        self.sub = sub
        self.jti = jti
        self.deviceID = deviceID
        self.tokenType = "auth_code"
        self.exp = Date().addingTimeInterval(60 * 5) // 5 mins
    }
    
}
