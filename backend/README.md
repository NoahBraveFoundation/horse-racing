# Horse Racing Backend

A Swift Vapor backend with GraphQL for the Horse Racing Fundraiser application.

## Prerequisites

- Swift 5.9+
- PostgreSQL 12+
- Vapor 4

## Database Setup

### 1. Install PostgreSQL

**macOS (using Homebrew):**
```bash
brew install postgresql
brew services start postgresql
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 2. Create Database User & Schema

Create a dedicated PostgreSQL role for Vapor and set the password to `vapor_password` (update this to something secure in production):

```bash
psql -U postgres -d postgres <<'SQL'
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'vapor_username') THEN
      CREATE ROLE vapor_username LOGIN PASSWORD 'vapor_password';
   ELSE
      ALTER ROLE vapor_username LOGIN PASSWORD 'vapor_password';
   END IF;
END $$;

CREATE DATABASE horse_racing_db OWNER vapor_username;
GRANT ALL PRIVILEGES ON DATABASE horse_racing_db TO vapor_username;
SQL
```

If you prefer CLI helpers, you can run:

```bash
createuser vapor_username --pwprompt
createdb horse_racing_db -O vapor_username
```

When prompted for the password, enter `vapor_password`.

### 3. Environment Configuration

Copy the example environment file and configure your database connection:

```bash
cp Database.env.example .env
```

Edit `.env` with your database credentials:
```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=vapor_username
DATABASE_PASSWORD=vapor_password
DATABASE_NAME=horse_racing_db
```

## Installation

1. Clone the repository and navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
swift package resolve
```

3. Build the project:
```bash
swift build
```

4. Run the application:
```bash
swift run
```

The server will start on `http://localhost:8080`

## GraphQL Endpoints

- **GraphQL**: `POST /graphql`
- **GraphiQL**: `GET /graphiql` (development only)
- **Health Check**: `GET /health`

## Authentication

The application uses session-based authentication with magic links:

1. **Request Magic Link**: `POST /auth/magic-link`
   - Body: `{"email": "user@example.com"}`

2. **Login via Magic Link**: `GET /auth/callback?token=<token>`

## Database Migrations

The application automatically runs migrations on startup. Current migrations include:

- `MigrateUsers` - User accounts with admin support
- `MigrateLoginTokens` - Magic link authentication tokens
- `MigrateRounds` - Racing rounds with timestamps
- `MigrateLanes` - Lanes within each round
- `MigrateHorses` - Horse entries with ownership
- `MigrateTickets` - Event tickets
- `MigrateSponsorInterests` - Company sponsorship
- `MigrateGiftBasketInterests` - Gift basket raffle
- `MigratePayments` - Payment tracking

## Sample Data

The application seeds sample data on first run:
- Admin user: `austinjevans@me.com` / `Austin Evans`
- 10 racing rounds starting at 8:00 PM ET on November 22, 2025
- 10 lanes per round

## Development

### Adding New Models

1. Create the model file in `Sources/HorseRacingBackend/Models/`
2. Add the migration to `HorseRacingBackend.swift`
3. Update the GraphQL schema in `GraphQL/Schema.swift`
4. Add resolver methods in `Resolvers/HorseResolver.swift`

### GraphQL Schema

The schema uses GraphQLKit's built-in helpers for Fluent relationships:
- `Field("relation", with: \.$relation)` for Parent/Children fields
- Automatic N+1 query prevention (though DataLoaders can be added later)

## Troubleshooting

### Common Issues

**Database Connection Failed:**
- Ensure PostgreSQL is running
- Check database credentials in `.env`
- Verify database `horse_racing_db` exists

**Migration Errors:**
- Drop and recreate the database if schema is corrupted
- Check migration order in `HorseRacingBackend.swift`

**Build Errors:**
- Run `swift package reset` to clear build cache
- Ensure all dependencies are resolved with `swift package resolve`
