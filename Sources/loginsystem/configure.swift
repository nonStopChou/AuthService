import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import Foundation


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    
    app.jwtService = JwtAccessTokenServiceImpl(app: app)
    app.refreshTokenService = RefreshTokenServiceImpl(app: app)
    
    let authAPI = app
        .grouped("api")
        .grouped(AuthMiddleware(accessTokenService: app.jwtService)
    )
    
    try database(app)
    // register routes
    try routes(app)
}
