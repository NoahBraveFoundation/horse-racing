# Horse Racing Backend

A Swift Vapor server with GraphQL support for the Horse Racing Fundraiser application.

## Features

- **Vapor 4**: Modern Swift web framework
- **GraphQL**: API with GraphQLKit
- **Models**: Horse and Race data models
- **Sample Data**: Pre-populated with sample horses and races

## Requirements

- Swift 6.2+
- macOS 13.0+
- PostgreSQL 13+ (running locally or accessible via network)

## Installation

1. Make sure you have Swift installed
2. Install and start PostgreSQL
3. Create a database for the application:
   ```bash
   createdb horse_racing_db
   ```
4. Navigate to the backend directory
5. Configure your database connection by setting environment variables or copying the example:
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```
6. Build the project:
   ```bash
   swift build
   ```

## Running the Server

```bash
swift run
```

The server will start on `http://localhost:8080`

## API Endpoints

- `GET /health` - Health check
- `GET /graphql` - GraphQL Playground (development)
- `POST /graphql` - GraphQL endpoint

## GraphQL Schema

### Queries

- `horses` - Get all horses
- `horse(id: ID!)` - Get a specific horse
- `races` - Get all races
- `race(id: ID!)` - Get a specific race

### Mutations

- `createHorse(name: String!, breed: String!, age: Int!, jockey: String!, odds: Float!)` - Create a new horse

### Types

#### Horse
- `id: ID!`
- `name: String!`
- `breed: String!`
- `age: Int!`
- `jockey: String!`
- `odds: Float!`

#### Race
- `id: ID!`
- `name: String!`
- `date: String!`
- `distance: Int!`
- `horses: [Horse!]!`
- `status: String!`

## Development

The project uses Swift Package Manager for dependency management. Dependencies are defined in `Package.swift`.

### Database Configuration

The application uses environment variables for database configuration:

- `DATABASE_HOST` - PostgreSQL host (default: localhost)
- `DATABASE_PORT` - PostgreSQL port (default: 5432)
- `DATABASE_USERNAME` - Database username (default: postgres)
- `DATABASE_PASSWORD` - Database password (default: empty)
- `DATABASE_NAME` - Database name (default: horse_racing_db)

### Migrations

The application automatically runs migrations on startup. The following tables are created:

- `horses` - Stores horse information with timestamps
- `races` - Stores race information with timestamps

## Sample Data

The application comes with sample data including:
- 4 sample horses with different breeds and odds
- 2 sample races (Kentucky Derby and Preakness Stakes)

## Next Steps

- Implement authentication and authorization
- Add more complex GraphQL operations (subscriptions, complex queries)
- Add real-time updates with WebSockets
- Implement betting functionality
- Add database indexing for performance
- Add comprehensive error handling
- Add API rate limiting
- Add logging and monitoring
