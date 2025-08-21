# Relay Setup for Horse Racing Fundraiser

This project has been set up with Relay for GraphQL integration.

## Installation

The following packages have been installed:
- `relay-runtime` - Core Relay runtime for React
- `graphql` - GraphQL support

## GraphQL Schema

To pull the GraphQL schema from your local backend:

```bash
npm run schema
```

This command will:
1. Connect to `localhost:8080/graphql`
2. Execute an introspection query
3. Save the schema to `schema.json`

**Note:** Make sure your backend GraphQL server is running on `localhost:8080` before running this command.

## Project Structure

```
src/
├── relay/
│   ├── environment.ts          # Relay environment configuration
│   └── RelayProvider.tsx      # Relay provider component
├── components/
│   └── ticket-flow/           # Ticket flow step components
│       ├── UserDetailsStep.tsx
│       ├── TicketSelectionStep.tsx
│       └── ConfirmationStep.tsx
├── types/
│   └── ticket.ts              # TypeScript interfaces
└── routes/
    └── TicketFlow.tsx         # Main ticket flow orchestrator
```

## Ticket Flow Architecture

The ticket purchase flow has been refactored into a multi-step process:

1. **User Details** - Collect user information and create user via GraphQL mutation
2. **Ticket Selection** - Choose ticket types and quantities
3. **Confirmation** - Review and confirm order

## Next Steps

To complete the Relay integration:

1. Run `npm run schema` to get the actual GraphQL schema
2. Install `relay-compiler` when disk space allows
3. Generate Relay artifacts from your GraphQL operations
4. Replace mock mutations with actual Relay mutations

## Current Implementation

- Relay environment is configured to connect to `localhost:8080/graphql`
- The app is wrapped with `RelayProvider`
- User creation mutation is prepared (currently mocked)
- Step-based navigation is implemented
- TypeScript interfaces are defined for type safety
