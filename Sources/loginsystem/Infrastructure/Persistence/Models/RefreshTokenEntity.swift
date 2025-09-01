//
//  RefreshTokenEntity.swift
//  loginsystem
//
//  Created by prchou on 2025/8/10.
//


import Fluent
import Vapor

final class RefreshTokenEntity: Model, @unchecked Sendable {
    
    static let schema: String = "JWT_REFRESH_TOKENS"

    @ID(custom: "ID", generatedBy: .user)
    var id: String?
    
    @Field(key: "TOKEN")
    var token: String
    
    @Field(key: "USER_ID")
    var userID: String
    
    @Field(key: "EXPIRES_AT")
    var expiresAt: Date
    
    @OptionalField(key: "DEVICE_ID")
    var deviceID: String?
    
    @Field(key: "REVOKED")
    var revoked: Bool
    
    @Timestamp(key: "CREATE_AT", on: .create)
    var createAt: Date?
    

    @Timestamp(key: "UPDATE_AT", on: .create)
    var updateAt: Date?
    
    init(){}
    
    init(token: String, userID: String, deviceID: String, expiresAt: Date, revoked: Bool = false) {
        self.id = UUID().uuidString
        self.token = token
        self.userID = userID
        self.expiresAt = expiresAt
        self.deviceID = deviceID
        self.revoked = revoked
    }
    
}
