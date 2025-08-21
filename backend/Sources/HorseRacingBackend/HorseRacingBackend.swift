import Vapor
import Fluent
import FluentPostgresDriver
import GraphQLKit
import GraphiQLVapor

@main
struct HorseRacingBackend {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)
        
        // Configure database
        try await configureDatabase(app)
        
        // Sessions (cookie-based)
        app.sessions.use(.memory)
        app.sessions.configuration.cookieName = "hrf_session"
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(UserSessionLoaderMiddleware())
        
        // Configure GraphQL
        try configureGraphQL(app)
        
        // Configure routes
        try configureRoutes(app)
        
        try await app.execute()
    }
}

struct UserSessionLoaderMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        if let userIDString = request.session.data["userID"], let userID = UUID(uuidString: userIDString) {
            if let user = try await User.find(userID, on: request.db) {
                request.auth.login(user)
            }
        }
        return try await next.respond(to: request)
    }
}

func configureDatabase(_ app: Application) async throws {
    // Configure PostgreSQL database
    // Use environment variables for database configuration
    let postgresConfig = SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "horse_racing_db",
        tls: .disable
    )
    
    app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    
    // Register migrations
    app.migrations.add(MigrateUsers())
    app.migrations.add(MigrateLoginTokens())
    app.migrations.add(MigrateHorses())
    app.migrations.add(MigrateRaces())
    
    // Run migrations
    try await app.autoMigrate()
    
    // Seed sample data if database is empty
    try await seedSampleData(app)
}

func configureGraphQL(_ app: Application) throws {
    // Register the schema and its resolver
    app.register(graphQLSchema: horseRacingSchema, withResolver: HorseResolver())
    
    // Enable GraphiQL web page to send queries to the GraphQL endpoint
    if !app.environment.isRelease {
        app.enableGraphiQL()
    }
    
    app.logger.info("GraphQL configured with schema")
}

func configureRoutes(_ app: Application) throws {
    // Basic health check route
    app.get("health") { req async throws -> String in
        return "Horse Racing Backend is running! 🐎"
    }

    // Magic link request: accepts email, creates user if needed, creates token, "sends" link
    app.post("auth", "magic-link") { req async throws -> HTTPStatus in
        struct Payload: Content { let email: String; let firstName: String?; let lastName: String? }
        let payload = try req.content.decode(Payload.self)
        let email = payload.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }

        var user = try await User.query(on: req.db).filter(\.$email == email).first()
        if user == nil {
            let newUser = User(email: email, firstName: payload.firstName ?? "", lastName: payload.lastName ?? "")
            try await newUser.create(on: req.db)
            user = newUser
        }
        guard let ensuredUser = user, let userID = ensuredUser.id else {
            throw Abort(.internalServerError, reason: "Failed to create or load user")
        }

        // Create token valid for 30 minutes
        let tokenString = [UUID().uuidString, UUID().uuidString].joined()
        let token = LoginToken(token: tokenString, userID: userID, expiresAt: Date().addingTimeInterval(30 * 60))
        try await token.create(on: req.db)

        // In real world, send email. For now, log the URL.
        let host = Environment.get("APP_HOST") ?? "http://localhost:8080"
        let link = "\(host)/auth/callback?token=\(tokenString)"
        req.logger.info("Magic link for \(email): \(link)")
        return .accepted
    }

    // Magic link callback: verify token, set session cookie, delete token
    app.get("auth", "callback") { req async throws -> Response in
        guard let tokenValue = try? req.query.get(String.self, at: "token") else {
            throw Abort(.badRequest, reason: "Missing token")
        }
        guard let loginToken = try await LoginToken.query(on: req.db).filter(\.$token == tokenValue).first() else {
            throw Abort(.unauthorized, reason: "Invalid token")
        }
        guard loginToken.expiresAt > Date() else {
            try await loginToken.delete(on: req.db)
            throw Abort(.unauthorized, reason: "Expired token")
        }
        let user = try await loginToken.$user.get(on: req.db)
        // Create session (store userID in session)
        requestSetAuthenticatedUser(req, user: user)
        // Consume the token
        try await loginToken.delete(on: req.db)
        // Respond
        let res = Response(status: .ok)
        res.headers.replaceOrAdd(name: .contentType, value: "application/json")
        try res.content.encode(["status": "ok", "userId": user.id?.uuidString ?? ""], as: .json)
        return res
    }
}

@inline(__always)
func requestSetAuthenticatedUser(_ req: Request, user: User) {
    if let id = user.id?.uuidString {
        req.session.data["userID"] = id
        req.auth.login(user)
    }
}

func seedSampleData(_ app: Application) async throws {
    // Check if we already have horses
    let horseCount = try await Horse.query(on: app.db).count()
    
    if horseCount == 0 {
        let sampleHorses = [
            Horse(name: "Thunder Bolt", breed: "Thoroughbred", age: 4, jockey: "John Smith", odds: 3.5),
            Horse(name: "Silver Arrow", breed: "Arabian", age: 5, jockey: "Sarah Johnson", odds: 2.8),
            Horse(name: "Golden Star", breed: "Quarter Horse", age: 3, jockey: "Mike Davis", odds: 4.2),
            Horse(name: "Swift Wind", breed: "Thoroughbred", age: 6, jockey: "Lisa Brown", odds: 1.9)
        ]
        
        for horse in sampleHorses {
            try await horse.create(on: app.db)
        }
        
        app.logger.info("Sample horses seeded")
    }
    
    // Check if we already have races
    let raceCount = try await Race.query(on: app.db).count()
    
    if raceCount == 0 {
        let sampleRaces = [
            Race(name: "Kentucky Derby", date: Date().addingTimeInterval(86400), distance: 2000, status: .upcoming),
            Race(name: "Preakness Stakes", date: Date().addingTimeInterval(172800), distance: 1900, status: .upcoming)
        ]
        
        for race in sampleRaces {
            try await race.create(on: app.db)
        }
        
        app.logger.info("Sample races seeded")
    }
}
