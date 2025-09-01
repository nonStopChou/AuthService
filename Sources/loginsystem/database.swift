import Vapor
import Fluent
import FluentMySQLDriver

struct DbConfiguration {
    
    let host: String
    let port: Int
    let username: String
    let password: String
    let database: String
    
    
    init? (){
        guard
            let host = Environment.get("DATABASE_HOSTNAME"),
              let portString = Environment.get("DATABASE_PORT"),
              let port = Int(portString),
              let username = Environment.get("DATABASE_USERNAME"),
              let password = Environment.get("DATABASE_PASSWORD"),
              let database = Environment.get("DATABASE_DATABASE") else {
                  return nil
              }
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.database = database
        
    }
    
}

func database(_ app: Application) throws {
    
    var tls = TLSConfiguration.makeClientConfiguration()
    if app.environment.name == "development" {
        tls.certificateVerification = .none
    }
    app.logger.info("Env : \(app.environment.name)")
    guard let dbConfig = DbConfiguration() else {
        fatalError("Missing required environment variables.")
    }
    
    app.logger.info(
        """
        DBConfiguration as following
        Hostname : \(dbConfig.host),
        Port : \(dbConfig.port),
        Username : \(dbConfig.username),
        Database : \(dbConfig.database)
        """
    )
    
    app.databases.use(.mysql(
        hostname: dbConfig.host,
        port: dbConfig.port,
        username: dbConfig.username,
        password: dbConfig.password,
        database: dbConfig.database,
        tlsConfiguration: tls
        
    ), as: .mysql)
    
    
}
