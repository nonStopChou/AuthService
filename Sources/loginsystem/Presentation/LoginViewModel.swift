//
//  LoginViewModel.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//
import Vapor

struct LoginViewModel: Content {
    
    let username: String
    let email: String
    let avartarURL: String
    let accessToken: String
    let refreshToken: String
    
    init(username: String, email:String, avartarURL: String, accessToken: String, refreshToken: String) {
        self.username = username
        self.email = email
        self.avartarURL = avartarURL
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
}
