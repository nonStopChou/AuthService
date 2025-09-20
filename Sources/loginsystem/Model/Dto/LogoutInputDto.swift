//
//  LogoutInputDto.swift
//  loginsystem
//
//  Created by prchou on 2025/9/2.
//
import Vapor

struct LogoutInputDto : Codable, Sendable{
    
    let refreshToken: String
    
}
