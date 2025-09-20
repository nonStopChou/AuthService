//
//  AuthCodeExchangeDto.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor

struct AuthCodeExchangeOutputDto: Content {
    
    let email: String
    let username: String
    let loginWith: String
    let avatarURL: String?
    let accessToken: String
    let refreshToken: String
    
}
