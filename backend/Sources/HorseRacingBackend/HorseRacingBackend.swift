import Vapor
import Fluent
import FluentPostgresDriver
import GraphQLKit
import GraphiQLVapor
import VaporWalletPasses
import WalletPasses

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
            allowedOrigin: .any(["https://horses.noahbrave.org", "http://localhost:5173", Environment.get("APP_HOST") ?? ""]),
            allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith],
            allowCredentials: true
        )
        app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
        
        // Sessions (cookie-based)
        app.sessions.use(.fluent)
        app.sessions.configuration.cookieName = "hrf_session"
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(UserSessionLoaderMiddleware())

                // Configure GraphQL
        try configureGraphQL(app)
        
        // Configure PassesServiceCustom
        try configurePassesService(app)
        
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

// MARK: - PassBuilder Service Storage

struct PassBuilderServiceKey: StorageKey {
    typealias Value = PassBuilder
}

extension Application {
    var passBuilderService: PassBuilder {
        get {
            self.storage[PassBuilderServiceKey.self] ?? {
                guard
                    let certBase64 = Environment.get("PASS_CERT_PEM"),
                    let certPassword = Environment.get("PASS_CERT_PASSWORD"),
                    let wwdrBase64 = Environment.get("PASS_WWDR_PEM"),
                    let privateKeyBase64 = Environment.get("PASS_PRIVATE_KEY_PEM")
                else {
                    fatalError("Missing Wallet env vars (PASS_*). Configure certificates to enable pass generation.")
                }
                guard 
                    let wwdrData = Data(base64Encoded: wwdrBase64),
                    let certData = Data(base64Encoded: certBase64),
                    let privateKeyData = Data(base64Encoded: privateKeyBase64),
                    let wwdrContent = String(data: wwdrData, encoding: .utf8),
                    let certContent = String(data: certData, encoding: .utf8),
                    let privateKeyContent = String(data: privateKeyData, encoding: .utf8)
                else {
                    fatalError("Failed to decode base64 certificate data")
                }
                let newService = PassBuilder(
                    pemWWDRCertificate: wwdrContent,
                    pemCertificate: certContent,
                    pemPrivateKey: privateKeyContent,
                    pemPrivateKeyPassword: certPassword.isEmpty ? nil : certPassword
                )
                self.storage[PassBuilderServiceKey.self] = newService
                return newService
            }()
        }
        set {
            self.storage[PassBuilderServiceKey.self] = newValue
        }
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
        tls: .prefer(try .init(configuration: .makeClientConfiguration()))
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
    app.migrations.add(MigrateTicketsAddSeatingPreference())
    app.migrations.add(MigrateTicketsAddSeatAssignment())
    app.migrations.add(MigrateSponsorInterests())
    app.migrations.add(MigrateSponsorInterestsAddCart())
    app.migrations.add(MigrateSponsorInterestsAddLogo())
    app.migrations.add(MigrateGiftBasketInterests())
    app.migrations.add(MigrateGiftBasketInterestsAddCart())
    app.migrations.add(MigratePayments())
    app.migrations.add(SessionRecord.migration)
    
    // Run migrations
    try await app.autoMigrate()
    
    // Seed sample data if database is empty
    try await seedSampleData(app)
}

func configureGraphQL(_ app: Application) throws {
    app.register(graphQLSchema: horseRacingSchema, withResolver: HorseResolver())
    if !app.environment.isRelease { app.enableGraphiQL() }
}

func configurePassesService(_ app: Application) throws {
    // Check if required environment variables are present
    guard
        Environment.get("PASS_CERT_PEM") != nil,
        Environment.get("PASS_WWDR_PEM") != nil,
        Environment.get("PASS_PRIVATE_KEY_PEM") != nil,
        Environment.get("PASS_CERT_PASSWORD") != nil
    else {
        app.logger.warning("⚠️ Pass configuration incomplete. Some environment variables missing.")
        app.logger.warning("Required: PASS_CERT_PEM, PASS_WWDR_PEM, PASS_PRIVATE_KEY_PEM, PASS_CERT_PASSWORD")
        app.logger.warning("Note: Certificate values should be base64-encoded PEM content")
        return
    }
    
    // Initialize the pass builder service (it's already configured in the extension)
    _ = app.passBuilderService
    
    app.logger.info("✅ PassBuilder service configured successfully")
}

func configureRoutes(_ app: Application) throws {
    app.get("health") { req async throws -> String in
        "Horse Racing Backend is running! 🐎"
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
