import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import Foundation



// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.logger.logLevel = .info   // 👈 show all info logs
    app.tokenService = TokenServiceImpl(app: app)

    try redis(app)
    
    try database(app)
    // register routes
    try routes(app)
}
