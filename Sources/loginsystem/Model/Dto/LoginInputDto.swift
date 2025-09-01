//
//  LoginDto.swift
//  hello
//
//  Created by prchou on 2025/7/24.
//

struct LoginDto: Codable, Sendable {
    let providerID: String
    let provider: String
    let deviceID: String
}
