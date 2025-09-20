//
//  SessionKV.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Foundation
import Redis
import NIOCore

struct SessionKV: Redisable {
   
    
    let sub: String
    let refreshJti: String
    let deviceID: String
    let exp: Date
    
    
    init(sub: String, refreshJti: String, deviceID: String, exp: Date) {
        self.sub = sub
        self.refreshJti = refreshJti
        self.deviceID = deviceID
        self.exp = exp
    }

    
    func toKey() -> String {
        return "user:\(sub):session"
    }
    
    
    func expiredAt() -> Date {
        return self.exp
    }
    
    
}

extension SessionKV {
    
    static func toKey(userID: String)-> String {
        return "user:\(userID):session"
    }
    
}
