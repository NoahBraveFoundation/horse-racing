# Sponsor Logo Editing Feature

## Overview
This feature allows admin users to edit sponsor logos directly from the admin dashboard.

## User Flow
1. Admin navigates to the dashboard at `/dashboard`
2. In the "Reports" section, sponsors are listed with their company logos
3. Admin clicks the "Edit Image" button next to any sponsor
4. A modal appears with the current logo (if any)
5. Admin can:
   - Drag and drop a new image file
   - Click to browse and select a file
   - Replace an existing logo
   - Remove the logo entirely
6. Admin clicks "Save" to update the logo
7. The modal closes and the sponsor list refreshes with the new logo

## Technical Implementation

### Backend (Swift/Vapor)
- **Mutation**: `adminUpdateSponsorLogo`
- **Location**: `backend/Sources/HorseRacingBackend/Resolvers/HorseResolver.swift`
- **Parameters**:
  - `sponsorInterestId: UUID!` - The ID of the sponsor to update
  - `companyLogoBase64: String?` - The new logo as a base64-encoded image (or null to remove)
- **Authorization**: Admin-only (checked via `request.auth.get(User.self).isAdmin`)
- **Returns**: Updated `SponsorInterest` object

### Frontend (React/TypeScript)
- **Component**: `SponsorLogoEditModal.tsx`
- **Location**: `frontend/src/components/admin/SponsorLogoEditModal.tsx`
- **Features**:
  - Drag-and-drop file upload
  - File type validation (images only)
  - File size limit (5MB)
  - Live preview
  - Replace/remove existing logo

- **Integration**: Dashboard.tsx
  - Added "Edit Image" button to sponsor table
  - Modal state management
  - GraphQL mutation execution

### GraphQL Schema
```graphql
type Mutation {
  adminUpdateSponsorLogo(
    sponsorInterestId: UUID!
    companyLogoBase64: String
  ): SponsorInterest!
}
```

## Security
- Only admin users can update sponsor logos
- File size limited to 5MB
- File type validation on frontend
- Base64 encoding sanitizes input
- CodeQL scan passed with 0 vulnerabilities

## Testing
- Backend builds successfully
- Frontend builds successfully with TypeScript type checking
- No new linting errors
- Security scan passed

## File Changes
### Backend
- `backend/Sources/HorseRacingBackend/GraphQL/Schema.swift`
- `backend/Sources/HorseRacingBackend/Resolvers/HorseResolver.swift`

### Frontend
- `frontend/src/components/Dashboard.tsx`
- `frontend/src/components/admin/SponsorLogoEditModal.tsx`
- `frontend/src/graphql/mutations/adminUpdateSponsorLogo.ts`
- `frontend/src/__generated__/DashboardUpdateSponsorLogoMutation.graphql.ts`
- `frontend/schema.json` (updated with new mutation)
- `frontend/.gitignore` (added backup file exclusion)
