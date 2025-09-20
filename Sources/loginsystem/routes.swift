import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AccountController())
    try app.register(collection: TokenController())
    try app.register(collection: UserController())
}
