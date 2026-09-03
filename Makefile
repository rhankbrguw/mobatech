.PHONY: setup run-backend run-crm run-ai run-flutter lint test

# ==============================================================================
# Setup Commands
# ==============================================================================
setup:
	@echo "Installing CRM dependencies..."
	cd mobatech-crm && npm install
	@echo "Installing Backend dependencies..."
	cd mobatech-backend && go mod tidy
	@echo "Installing AI dependencies..."
	cd mobatech-ai && pip install -r requirements.txt || echo "No requirements.txt found"
	@echo "Installing Flutter dependencies..."
	cd mobatech-flutter && flutter pub get
	@echo "Setup complete!"
	@echo "Setting up environment variables..."
	@test -f mobatech-crm/.env || cp mobatech-crm/.env.example mobatech-crm/.env
	@test -f mobatech-backend/.env || cp mobatech-backend/.env.example mobatech-backend/.env
	@test -f mobatech-flutter/.env || cp mobatech-flutter/.env.example mobatech-flutter/.env
	@test -f mobatech-ai/.env || cp mobatech-ai/.env.example mobatech-ai/.env
	@echo "Environment variables created from examples."

db-reset:
	@echo "Resetting MySQL database and seeding clean baseline data..."
	@cd mobatech-backend && mysql -u root -p$$(grep -E '^DB_PASSWORD=' .env | cut -d '=' -f2) -h $$(grep -E '^DB_HOST=' .env | cut -d '=' -f2 || echo 127.0.0.1) -e "DROP DATABASE IF EXISTS mobatech; CREATE DATABASE mobatech;"
	@cd mobatech-backend && go run cmd/seed/main.go
	@echo "Database reset and seeded successfully!"

# ==============================================================================
# Run Commands
# ==============================================================================
run-backend:
	cd mobatech-backend && go run main.go

run-crm:
	cd mobatech-crm && npm run dev

run-ai:
	cd mobatech-ai && PYTHONPATH=src uvicorn api:app --reload --port $$(grep -E '^(PORT|API_PORT)=' .env 2>/dev/null | head -n 1 | cut -d '=' -f2 | tr -d ' ' || echo 8000)

run-flutter:
	cd mobatech-flutter && flutter run

build-apk:
	@echo "Building optimized Release APK..."
	cd mobatech-flutter && flutter build apk --release
	@cp -f mobatech-flutter/build/app/outputs/flutter-apk/app-release.apk mobatech-flutter/build/app/outputs/flutter-apk/mobatech-v1.0.0.apk 2>/dev/null || true
	@echo "Build complete! Output: mobatech-flutter/build/app/outputs/flutter-apk/mobatech-v1.0.0.apk"

# ==============================================================================
# Linting & Verification
# ==============================================================================
lint:
	cd mobatech-backend && go vet ./...
	cd mobatech-crm && npx eslint src/ && npx tsc --noEmit
	cd mobatech-flutter && flutter analyze
	cd mobatech-ai && python3 -m flake8 src/

test:
	cd mobatech-backend && go test ./...
	cd mobatech-flutter && flutter test
