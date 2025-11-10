# TODO List

- [x] Use green theme for accent colors, #239F09
- [x] Fix login. See the `frontend` code for login and queries. There are no passwords, instead login happens through magic links. We need to update to open links in app for `https://horses.noahbrave.org` and use value to login. If not a login link, redirect to web.
- [ ] Fix logout button
- [ ] Use tab bar for navigation, moving detailed stats to new tab
- [ ] Add view that shows all tickets and has a search feature

- [ ] Add https://github.com/MacPaw/OpenAI to the backend and make a audio speech call to OpenAI to get a audio file of the horses the user has purchased. Call this API as mutation from ticket client when user's ticket is scanned. Add to queue so that it happens in background and not blocking the scan. Play as soon as ready. Show toast UI when playing. Continue to show toast for 15 seconds after audio ends so user can replay if needed.
- [ ] Scan dates are incorrect, showing Nov 9, 1994 for some reason. Fix date formatting.
- [ ] Debounce tickt scans to prevent multiple scans of same ticket in quick succession.

