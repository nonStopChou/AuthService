//
//  AuthConfig.swift
//  loginsystem
//
//  Created by prchou on 2025/8/27.
//


protocol AuthConfig {
    
    var clientID: String { get }
    var clientSecret: String { get }
    var redirectURL: String { get }
    var tokenURL: String { get }
    var userProfileURL: String { get }
    
    
}
