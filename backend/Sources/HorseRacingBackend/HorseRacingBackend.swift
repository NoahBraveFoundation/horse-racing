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

      do {
        // Configure database
        try await configureDatabase(app)

        // CORS middleware
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
        )
        app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
        
        // Sessions (cookie-based)
        app.sessions.use(.memory)
        app.sessions.configuration.cookieName = "hrf_session"
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(UserSessionLoaderMiddleware())

                // Configure GraphQL
        try configureGraphQL(app)
        
        // Configure scheduled tasks
        try configureScheduledTasks(app)
        
        // Configure routes
        try configureRoutes(app)

        try await app.execute()
      } catch {
        app.logger.report(error: error)
        try? await app.asyncShutdown()
        throw error
      }

      app.logger.info("Shutting down application")
      try await app.asyncShutdown()
      app.logger.info("Application shut down")
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
    let postgresConfig = SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "horse_racing_db",
        tls: .disable
    )
    
    app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    
    // Register migrations
    app.migrations.add(MigrateUsers())
    app.migrations.add(MigrateLoginTokens())
    app.migrations.add(MigrateCarts())
    app.migrations.add(MigrateRounds())
    app.migrations.add(MigrateLanes())
    app.migrations.add(MigrateHorses())
    app.migrations.add(MigrateHorsesAddCart())
    app.migrations.add(MigrateTickets())
    app.migrations.add(MigrateTicketsAddState())
    app.migrations.add(MigrateTicketsAddCart())
    app.migrations.add(MigrateTicketsAddCanRemove())
    app.migrations.add(MigrateSponsorInterests())
    app.migrations.add(MigrateSponsorInterestsAddCart())
    app.migrations.add(MigrateSponsorInterestsAddLogo())
    app.migrations.add(MigrateGiftBasketInterests())
    app.migrations.add(MigrateGiftBasketInterestsAddCart())
    app.migrations.add(MigratePayments())
    
    // Run migrations
    try await app.autoMigrate()
    
    // Seed sample data if database is empty
    try await seedSampleData(app)
}

func configureGraphQL(_ app: Application) throws {
    app.register(graphQLSchema: horseRacingSchema, withResolver: HorseResolver())
    if !app.environment.isRelease { app.enableGraphiQL() }
}

func configureScheduledTasks(_ app: Application) throws {
    // Cleanup service is ready for manual or scheduled execution
    app.logger.info("CleanupService configured - use /admin/cleanup endpoint to run manually")
}

func configureRoutes(_ app: Application) throws {
    app.get("health") { req async throws -> String in
        "Horse Racing Backend is running! 🐎"
    }

    app.post("auth", "magic-link") { req async throws -> HTTPStatus in
        struct Payload: Content { let email: String }
        let payload = try req.content.decode(Payload.self)
        let email = payload.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }
        guard let user = try await User.query(on: req.db).filter(\.$email == email).first(), let userID = user.id else {
            throw Abort(.notFound, reason: "No account found for this email")
        }
        let token = AuthService.generateSecureLoginToken(for: userID)
        try await token.create(on: req.db)
        let host = Environment.get("APP_HOST") ?? "http://localhost:8080"
        let link = "\(host)/auth/callback?token=\(token.token)"
        req.logger.info("Magic link for \(email): \(link)")
        return .accepted
    }

    app.get("auth", "callback") { req async throws -> Response in
        guard let tokenValue = try? req.query.get(String.self, at: "token") else { throw Abort(.badRequest, reason: "Missing token") }
        guard let loginToken = try await LoginToken.query(on: req.db).filter(\.$token == tokenValue).first() else { throw Abort(.unauthorized, reason: "Invalid token") }
        guard loginToken.expiresAt > Date() else { try await loginToken.delete(on: req.db); throw Abort(.unauthorized, reason: "Expired token") }
        let user = try await loginToken.$user.get(on: req.db)
        AuthService.setAuthenticatedUser(req, user: user)
        try await loginToken.delete(on: req.db)
        let res = Response(status: .ok)
        res.headers.replaceOrAdd(name: .contentType, value: "application/json")
        try res.content.encode(["status": "ok", "userId": user.id?.uuidString ?? ""], as: .json)
        return res
    }
    
    // Admin cleanup endpoint
    app.post("admin", "cleanup") { req async throws -> HTTPStatus in
        // Check if user is admin
        guard let user = req.auth.get(User.self), user.isAdmin else {
            throw Abort(.forbidden, reason: "Admin access required")
        }
        
        try await withCheckedThrowingContinuation { continuation in
            CleanupService.runAllCleanups(on: req)
                .whenComplete { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
        
        req.logger.info("Manual cleanup completed by admin user: \(user.email)")
        return .ok
    }
}



func seedSampleData(_ app: Application) async throws {
    // Seed admin user
    if try await User.query(on: app.db).filter(\.$email == "austinjevans@me.com").first() == nil {
        let admin = User(email: "austinjevans@me.com", firstName: "Austin", lastName: "Evans", isAdmin: true)
        try await admin.create(on: app.db)
        app.logger.info("Seeded admin user austinjevans@me.com")
    }

    // Seed 10 rounds starting at 8 PM ET Nov 22, 2025, each 30 minutes apart
    let roundCount = try await Round.query(on: app.db).count()
    if roundCount == 0 {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York") ?? .current
        let components = DateComponents(year: 2025, month: 11, day: 22, hour: 20, minute: 0)
        guard let baseStart = calendar.date(from: components) else { return }

        var createdRounds: [Round] = []
        for i in 0..<10 {
            let start = baseStart.addingTimeInterval(TimeInterval(i * 30 * 60))
            let end = start.addingTimeInterval(30 * 60)
            let round = Round(name: "Round \(i + 1)", startAt: start, endAt: end)
            try await round.create(on: app.db)
            createdRounds.append(round)
        }
        app.logger.info("Seeded 10 rounds from 8:00 PM ET with 30-min intervals")

        // Create 10 lanes per round
        for r in createdRounds {
            guard let rid = r.id else { continue }
            for n in 1...10 {
                try await Lane(roundID: rid, number: n).create(on: app.db)
            }
        }
        app.logger.info("Seeded 10 lanes per round")
    }
}
