//
//  TokenRepository.swift
//  loginsystem
//
//  Created by prchou on 2025/9/20.
//
import Foundation

protocol KVRepository {
    
    func contains(key: String) async throws -> Bool
    
    func save(object: any Redisable) async throws
    
    func saveExpired(object: any Redisable) async throws
    
    func remove(key: String) async throws
    
}
