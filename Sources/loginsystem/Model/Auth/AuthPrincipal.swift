//
//  AuthProfile.swift
//  loginsystem
//
//  Created by prchou on 2025/8/9.
//
import Vapor

struct AuthPrincipal {
    
    let username: String
    let email: String
    let provider: Provider
    let providerID: String
    let avatarURL: String
    
}
