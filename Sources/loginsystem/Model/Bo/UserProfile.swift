//
//  UserProfile.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//
import Vapor


struct UserProfile: Sendable {
    let id: String
    let email: String
    let username: String
    let provider: Provider
    let providerID: String
    let avatarURL: String?
    let lastLoginDate: Date
    
    init(id: String, email: String, username: String, provider: Provider, providerID: String, avatarURL: String?, lastLoginDate: Date) {
        self.id = id
        self.email = email
        self.username = username
        self.provider = provider
        self.providerID = providerID
        self.avatarURL = avatarURL
        self.lastLoginDate = lastLoginDate
    }
    
}
