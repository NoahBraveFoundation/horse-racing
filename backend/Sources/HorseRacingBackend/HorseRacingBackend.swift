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
        
        // Configure GraphQL
        try configureGraphQL(app)
        
        // Configure routes
        try configureRoutes(app)
        
        try await app.execute()
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
