//
//  GetMeOutputDto.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor
struct GetMeOutputDto: Content {
    
    let email: String
    let username: String
    let loginWith: String
    let avatarURL: String?
    
}
