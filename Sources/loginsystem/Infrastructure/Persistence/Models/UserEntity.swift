//
//  User.swift
//  hello
//
//  Created by prchou on 2025/7/21.
//

import Fluent
import Vapor


final class UserEntity: Model, @unchecked Sendable{
    
    static let schema = SchemaConfig.USER_MAIN_TABLE
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "provider")
    var provider: String
    
    @Field(key: "provider_id")
    var providerID: String
    
    @Field(key: "plan")
    var plan: String
    
    @OptionalField(key: "avatar_url")
    var avatarURL: String?
    
    @Timestamp(key: "create_at", on: .create)
    var createAt: Date?
    
    @Timestamp(key: "update_at", on: .update)
    var updateAt: Date?
    
    init() {}
    
    init(email: String, username: String, provider: String, providerID: String, avatarURL: String
    ) {
        self.id = UUID().uuidString
        self.email = email
        self.username = username
        self.provider = provider
        self.providerID = providerID
        self.avatarURL = avatarURL
        self.plan = "free"
    }
    
    func willCreate(on: any Database) throws -> Void {
        self.updateAt = Date()
    }
    
    
}
