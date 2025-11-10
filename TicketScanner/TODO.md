# TODO List

- [x] Use green theme for accent colors, #239F09
- [x] Fix login. See the `frontend` code for login and queries. There are no passwords, instead login happens through magic links. We need to update to open links in app for `https://horses.noahbrave.org` and use value to login. If not a login link, redirect to web.
- [ ] Fix logout button
- [ ] Use tab bar for navigation, moving detailed stats to new tab
- [ ] Add view that shows all tickets and has a search feature

- [ ] Add https://github.com/MacPaw/OpenAI to the backend and make a audio speech call to OpenAI to get a audio file of the horses the user has purchased. Call this API as mutation from ticket client when user's ticket is scanned. Add to queue so that it happens in background and not blocking the scan. Play as soon as ready. Show toast UI when playing. Continue to show toast for 15 seconds after audio ends so user can replay if needed.
- [ ] Scan dates are incorrect, showing Nov 9, 1994 for some reason. Fix date formatting.

## Phase 1
- [x] Add Apollo middleware logging for requests and responses.
- [x] Debounce ticket scans to prevent multiple scans of same ticket in quick succession.
- [x] Queue ticket scans to handle multiple scans in quick succession.
- [x] Add haptic feedback on ticket scan results.
- [x] Play success.wav and failure.wav sounds on ticket scan results.

## Phase 2
- [x] Investigate bug where sheet sometimes doesn't appear when scanning tickets. Use swift navigation from tca if not already.
- [x] Support searching ticket by id.
- [x] In all tickets view, show scanned status with green check. Allow filtering by scanned/unscanned/all.
- [x] Allow manual scan in all tickets view by adding detail view with button labeled "Scan" in navigation bar.
- [x] Implement location services to log where tickets are scanned. If possible, use apple maps to get location name.
- [x] Add swipe to unscan ticket in all tickets view and stats view.
- [x] Tapping ticket in stats view should open ticket detail view.

## Phase 3

- [x] Add horse information to ticket details view (scanning and all tickets).
- [x] Add horse board like frontend web app with navigation button on all tickets view.
- [ ] Add settings tab, allow turning on/off haptics, audio feedback, and audio clip greetings. Move logout button here.
- [ ] Allow user to adjust seating assignment in ticket details view. Push new view with editable text view.
- [ ] Add a TCA logger for state and actions for easier debugging.

## Phase 4
- [ ] Publish to TestFlight on push to main branch if touches ticket sources with github actions.
- [ ] Move "Scan" to primary button on bottom right next to tab bar.
