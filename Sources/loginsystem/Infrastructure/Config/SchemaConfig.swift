//
//  SchemaConfig.swift
//  loginsystem
//
//  Created by prchou on 2025/8/9.
//

import Vapor

struct SchemaConfig {
    
    static let USER_MAIN_TABLE: String = Environment.get("USER_MAIN_TABLE") ?? "TK_USER"
}
