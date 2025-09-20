//
//  GetAuthUrlDto.swift
//  loginsystem
//
//  Created by prchou on 2025/8/31.
//
import Vapor

struct GetAuthUrlDto: Codable, Sendable {
    let deviceID: String
    let appScheme: String
}
