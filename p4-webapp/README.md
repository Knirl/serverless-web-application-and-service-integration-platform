# Service Request Tracker (frontend only)

Vanilla HTML/CSS/JS. Open `index.html` in a browser, or run `python3 -m http.server` and visit http://localhost:8000.

- `js/data.js` – mock data and dropdown options (delete when the API exists)
- `js/api.js` – the only place that touches data: `getRequests`, `getRequest`, `createRequest`, `updateRequest`, `deleteRequest`
- `js/app.js` – UI logic; calls only the functions in `api.js`

## Connecting AWS later
Replace the bodies in `api.js` with `fetch()` calls to API Gateway (`GET/POST /requests`, `GET/PUT/DELETE /requests/{id}`). Functions are already async, so `app.js` needs no changes. Note: DynamoDB-backed fields `id`, `createdAt`, `updatedAt` should be set by the backend.
