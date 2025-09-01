import Fluent

struct CreateUserTable: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaConfig.USER_MAIN_TABLE)
            .field("id", .string, .identifier(auto: false))
            .field("email", .string, .required)
            .field("username", .string, .required)
            .field("provider", .string, .required)
            .field("provider_id", .string, .required)
            .field("avatar_url", .string)
            .field("create_at", .datetime)
            .field("update_at", .datetime)
            .field("plan", .string, .sql(.default("free")))
            .unique(on: "provider", "provider_id", name: "idx_provider")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("TK_USER").delete()
    }
}
