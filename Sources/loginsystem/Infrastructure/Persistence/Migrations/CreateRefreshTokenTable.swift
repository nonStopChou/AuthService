//
//  CreateRefreshTokenTable.swift
//  loginsystem
//
//  Created by prchou on 2025/8/17.
//
import Fluent
import SQLKit

struct CreateRefreshTokenTable: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("JWT_REFRESH_TOKENS")
            .field("ID", .string, .identifier(auto: false)) // VARCHAR(36) PK
            .field("USER_ID", .string, .required, .references("TK_USER", "id", onDelete: .cascade))
            .field("TOKEN", .string, .required) // text → string (可改 .sql(raw: "TEXT") 若要原樣)
            .field("EXPIRES_AT", .datetime, .required)
            .field("REVOKED", .bool, .required, .sql(.default(false)))
            .field("DEVICE_ID", .string, .required)
            .field("CREATE_AT", .datetime)
            .field("UPDATE_AT", .datetime)
            .unique(on: "USER_ID", name: "JWT_REFRESH_TOKENS_UNIQUE_1")
            .create()
        
        if let sql = database as? any SQLDatabase {
            try await sql.raw("""
                    CREATE INDEX JWT_REFRESH_TOKENS_EXPIRES_AT_IDX 
                    ON JWT_REFRESH_TOKENS (EXPIRES_AT)
                """).run()
        }
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("JWT_REFRESH_TOKENS").delete()
    }
}
