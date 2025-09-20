//
//  redis.swift
//  loginsystem
//
//  Created by prchou on 2025/9/10.
//
import Foundation
import Vapor
import Redis

struct ApRedisConnection {
    
    let host: String
    let port: Int
//    let password: String
    
    
    init? (){
        guard
              let host = Environment.get("REDIS_HOST"),
              let portString = Environment.get("REDIS_PORT"),
              let port = Int(portString)
//              let password = Environment.get("REDIS_PASSWORD")
          else {
              return nil
          }
        self.host = host
        self.port = port
//        self.password = password

    }
    
}


func redis(_ app: Application) throws {
    
    guard let redisConfig = ApRedisConnection() else {
        fatalError("Missing required environment variables.")
    }
    
    
    app.logger.info(
        """
        RedisConfig as following
        Hostname : \(redisConfig.host),
        Port : \(redisConfig.port)
        """
    )
    
    app.redis.configuration = try RedisConfiguration(
        hostname: redisConfig.host,
        port: redisConfig.port
//        password: redisConfig.password
    )
    
    app.logger.info("Connect to Redis Successfully.")
    
}
