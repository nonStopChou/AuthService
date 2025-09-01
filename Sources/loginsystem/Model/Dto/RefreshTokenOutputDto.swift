//
//  RefreshTokenOutputDto.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//

import Vapor

struct RefreshTokenOutputDto: Content {
    
    let accessToken: String
    let refreshToken: String
    
}
