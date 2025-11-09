# TODO List

- [x] Use green theme for accent colors, #239F09
- [x] Fix login. See the `frontend` code for login and queries. There are no passwords, instead login happens through magic links. We need to update to open links in app for `https://horses.noahbrave.org` and use value to login. If not a login link, redirect to web.

## Completed Items

✅ **Green Theme Implementation**
- Created `Colors.swift` with `.brandGreen` color extension
- Updated `LoginView` to use green theme for icon and button
- Updated `ScanningView` to use green theme for scanning indicator

✅ **Magic Link Authentication**
- Removed password-based login from `AuthenticationFeature`
- Implemented `sendMagicLink` action to request magic link via email
- Implemented `validateToken` action to authenticate with token from link
- Updated `LoginView` to show email-only form with success state
- Updated `APIClient` with `sendMagicLink` and `validateToken` methods

✅ **Deep Link Support**
- Added URL scheme `ticketscanner://` to project configuration
- Added universal links support for `https://horses.noahbrave.org/auth-callback`
- Created `TicketScannerApp.entitlements` with associated domains
- Updated `AppFeature` with `handleDeepLink` action
- Added `.onOpenURL` handler in `AppView` to process incoming deep links
- Created `apple-app-site-association` file for universal links

## Notes

- The app now sends a magic link to the user's email
- When the user taps the link, it opens the app via universal link or URL scheme
- The token is extracted from the URL and validated via the API
- On successful validation, the user is logged in and navigated to the scanning view
- Non-auth URLs will open in Safari as a fallback

