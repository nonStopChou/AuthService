//
//  AccessToken.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//


import Foundation

struct AccessToken {
    
    let sub: String
    let jti: String
    let tokenType: String
    let exp: Date

    init(sub: String, jti: String) {
        self.sub = sub
        self.jti = jti
        self.tokenType = "access_token"
        self.exp = Date().addingTimeInterval(60 * 15) // 15 mins
    }
    
    
}
