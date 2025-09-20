//
//  KVRepositoryImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/20.
//

import Vapor
import Foundation
import Redis

struct KVRepositoryImpl: KVRepository {
    
    
    let redis: any RedisClient
    
    
    func saveExpired(object: any Redisable) async throws {
        try await redis.set(RedisKey(object.toKey()),
                            to: object,
                            onCondition: .none,
                            expiration: .seconds(Int(object.expiredAt().timeIntervalSince(Date()))))
    }
    
    
    func contains(key: String) async throws -> Bool {
        return try await redis.exists(RedisKey(key)).get() > 0
    }
    
    func save(object: any Redisable) async throws {
        try await redis.set(RedisKey(object.toKey()), to: object).get()
    }
    
    func remove(key: String) async throws {
        try await redis.delete(RedisKey(key)).get()
    }
    
    
}


extension Application {
    
    var kvRepository : any KVRepository {
        KVRepositoryImpl(redis: self.redis)
    }
    
}
