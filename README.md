# Mobatech Healthcare Ecosystem

Hospital management and telemedicine platform. Go backend, Next.js CRM, Flutter mobile app, Python service for AI diagnostics. MySQL for storage, also vector DB for embeddings.

---

Clone it, copy `.env.example` to `.env` in each of `mobatech-flutter`, `mobatech-backend`, `mobatech-crm`, `mobatech-ai`, then run `make setup` to pull everything.

Database: `make db-reset` (resets MySQL `mobatech` database, runs auto-migration, and seeds baseline accounts for Admin, Doctor, Pharmacist, and Patient with password `Password123`).

Backend: `cd mobatech-backend && go mod tidy && go run main.go` or `make run-backend` (runs on `:8080`).

CRM: `cd mobatech-crm && npm install && npm run dev` or `make run-crm` (runs on `:3000`).

AI Service: `cd mobatech-ai && uvicorn api:app --reload --port 8000` or `make run-ai`.

Mobile: `cd mobatech-flutter && flutter pub get && flutter run` or `make run-flutter`. Build release APK with `make build-apk` or `cd mobatech-flutter && flutter build apk --release` (outputs `mobatech-v1.0.0.apk`).

Production: `npm run build && npm run start` for the CRM, `go build -o mobatech-server && ./mobatech-server` for the backend.

---

Requires Go 1.21+, Node 18+, Flutter 3.19+, Python 3.10+, MySQL 8+.
