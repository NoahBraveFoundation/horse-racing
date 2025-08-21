# Horse Racing Fundraiser

A full-stack application for managing horse racing fundraisers with a modern React frontend and Swift Vapor GraphQL backend.

## Project Structure

```
horse-racing-fundraiser/
├── frontend/          # React + TypeScript + Vite + Tailwind
├── backend/           # Swift Vapor + GraphQL
└── README.md          # This file
```

## Quick Start

### Frontend (React)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open [http://localhost:5173](http://localhost:5173) in your browser

### Backend (Swift Vapor)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Build the project:
   ```bash
   swift build
   ```

3. Run the server:
   ```bash
   swift run
   ```

4. The server will be available at [http://localhost:8080](http://localhost:8080)

## Features

### Frontend
- **React 18** with TypeScript
- **Vite** for fast development and building
- **Tailwind CSS** for styling
- **Responsive design** with mobile-first approach
- **Hot Module Replacement** for development

### Backend
- **Swift Vapor 4** web framework
- **GraphQL API** with GraphQLKit
- **Horse and Race models** with sample data
- **GraphQL Playground** for API testing
- **Health check endpoint**

## API Endpoints

- `GET /health` - Backend health check
- `GET /graphql` - GraphQL Playground
- `POST /graphql` - GraphQL API endpoint

## GraphQL Schema

The backend provides a GraphQL API with:

- **Queries**: Fetch horses and races
- **Mutations**: Create new horses
- **Types**: Horse and Race with full field definitions

## Development

### Prerequisites

- **Frontend**: Node.js 18+, npm/yarn
- **Backend**: Swift 6.2+, macOS 13.0+

### Technology Stack

- **Frontend**: React, TypeScript, Vite, Tailwind CSS
- **Backend**: Swift, Vapor, GraphQLKit
- **API**: GraphQL
- **Styling**: Tailwind CSS utility classes

## Sample Data

The application comes with sample data including:
- 4 sample horses with different breeds and odds
- 2 sample races (Kentucky Derby and Preakness Stakes)

## License

This project is open source and available under the [MIT License](LICENSE).
