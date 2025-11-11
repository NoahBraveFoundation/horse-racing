# Ticket Scanner Makefile

# Configuration
BACKEND_URL = http://localhost:8080
SCHEMA_FILE = schema.graphqls
GENERATED_DIR = Generated
INTROSPECTION_QUERY = '{"query":"query IntrospectionQuery { __schema { queryType { name } mutationType { name } subscriptionType { name } types { ...FullType } directives { name description locations args { ...InputValue } } } } fragment FullType on __Type { kind name description fields(includeDeprecated: true) { name description args { ...InputValue } type { ...TypeRef } isDeprecated deprecationReason } inputFields { ...InputValue } interfaces { ...TypeRef } enumValues(includeDeprecated: true) { name description isDeprecated deprecationReason } possibleTypes { ...TypeRef } } fragment InputValue on __InputValue { name description type { ...TypeRef } defaultValue } fragment TypeRef on __Type { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } } } } }"}'
FASTLANE_ENV_FILE = Signing/fastlane.env
APPLE_TEAM_ID ?= VSK4YJB7D8
APP_SCHEME ?= TicketScannerApp
APP_PROJECT_PATH ?= TicketScannerApp/TicketScannerApp.xcodeproj
APP_BUNDLE_ID ?= org.noahbrave.app.ticketscanner
PROVISIONING_PROFILE_PATH ?= Signing/NBFTickets.mobileprovision

# Default target
.PHONY: help
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Check dependencies
.PHONY: check-deps
check-deps: ## Check if required tools are installed
	@echo "Checking dependencies..."
	@command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed."; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "Error: jq is required but not installed. Install with: brew install jq"; exit 1; }
	@echo "All dependencies are available."

# Schema management
.PHONY: update-schema
update-schema: ## Fetch schema from backend and update schema.graphqls
	@echo "Fetching GraphQL schema from $(BACKEND_URL)/graphql..."
	@if [ ! -f apollo-ios-cli ]; then \
		echo "Installing Apollo iOS CLI..."; \
		swift package --allow-writing-to-package-directory apollo-cli-install; \
	fi
	@./apollo-ios-cli fetch-schema --path apollo-codegen-config.json
	@if [ $$? -eq 0 ]; then \
		echo "✓ Schema downloaded and saved to $(SCHEMA_FILE)"; \
	else \
		echo "Error: Failed to fetch schema. Is the backend running at $(BACKEND_URL)?"; \
		exit 1; \
	fi

# Code generation
.PHONY: generate-apollo
generate-apollo: ## Generate Apollo Swift code from GraphQL operations
	@echo "Generating Apollo code..."
	@if [ ! -f apollo-ios-cli ]; then \
		echo "Installing Apollo iOS CLI..."; \
		swift package --allow-writing-to-package-directory apollo-cli-install; \
	fi
	@if [ ! -f $(SCHEMA_FILE) ]; then \
		echo "Schema file not found, fetching from backend..."; \
		./apollo-ios-cli fetch-schema --path apollo-codegen-config.json || { \
			echo "Error: Could not fetch schema. Is the backend running at $(BACKEND_URL)?"; \
			exit 1; \
		}; \
	fi
	@./apollo-ios-cli generate --ignore-version-mismatch
	@echo "✓ Apollo code generated successfully in Generated/"

.PHONY: clean-generated
clean-generated: ## Clean generated Apollo code
	@echo "Cleaning generated code..."
	@rm -rf $(GENERATED_DIR)/
	@echo "Generated code cleaned. Run 'make generate-apollo' to regenerate."

# iOS project management
.PHONY: build-ios
build-ios: ## Build iOS project (requires Xcode)
	@echo "Building iOS project..."
	@xcodebuild -project TicketScannerApp/TicketScannerApp.xcodeproj -scheme TicketScannerApp -destination 'platform=iOS Simulator,name=iPhone 16' -skipMacroValidation build | xcbeautify

.PHONY: test-ios
test-ios: ## Run iOS tests
	@echo "Running iOS tests..."
	@xcodebuild -project TicketScannerApp/TicketScannerApp.xcodeproj -scheme TicketScannerApp -destination 'platform=iOS Simulator,name=iPhone 16' -skipMacroValidation test | xcbeautify

.PHONY: clean-ios
clean-ios: ## Clean iOS build artifacts
	@echo "Cleaning iOS build artifacts..."
	@xcodebuild -project TicketScannerApp/TicketScannerApp.xcodeproj -scheme TicketScannerApp clean | xcbeautify
	@echo "iOS build artifacts cleaned"

.PHONY: fastlane-testflight
fastlane-testflight: ## Build and upload a TestFlight build with fastlane (requires Signing assets)
	@if [ ! -f Signing/AppStoreConnect.p8 ]; then \
		echo "Error: Signing/AppStoreConnect.p8 not found."; \
		echo "Place your App Store Connect API key in app/Signing before running this target."; \
		exit 1; \
	fi
	@if [ ! -f $(PROVISIONING_PROFILE_PATH) ]; then \
		echo "Error: Provisioning profile not found at $(PROVISIONING_PROFILE_PATH)."; \
		echo "Place your .mobileprovision file in app/Signing or override PROVISIONING_PROFILE_PATH."; \
		exit 1; \
	fi
	@if ! command -v fastlane >/dev/null 2>&1; then \
		echo "Error: fastlane not installed. Install with: gem install fastlane"; \
		exit 1; \
	fi
	@if [ -f $(FASTLANE_ENV_FILE) ]; then \
		set -a; \
		source $(FASTLANE_ENV_FILE); \
		set +a; \
	fi; \
	if [ -z "$$APP_STORE_CONNECT_API_KEY_ID" ]; then \
		echo "Error: APP_STORE_CONNECT_API_KEY_ID must be set (export it or add to $(FASTLANE_ENV_FILE))."; \
		exit 1; \
	fi; \
	if [ -z "$$APP_STORE_CONNECT_API_ISSUER_ID" ]; then \
		echo "Error: APP_STORE_CONNECT_API_ISSUER_ID must be set (export it or add to $(FASTLANE_ENV_FILE))."; \
		exit 1; \
	fi; \
	PROFILE_PLIST=$$(mktemp); \
	security cms -D -i $(PROVISIONING_PROFILE_PATH) > $$PROFILE_PLIST; \
	PROFILE_UUID=$$(/usr/libexec/PlistBuddy -c 'Print UUID' $$PROFILE_PLIST); \
	PROFILE_NAME=$$(/usr/libexec/PlistBuddy -c 'Print Name' $$PROFILE_PLIST); \
	rm $$PROFILE_PLIST; \
	export PROFILE_UUID="$$PROFILE_UUID"; \
	export PROFILE_NAME="$$PROFILE_NAME"; \
	export APP_SCHEME=$(APP_SCHEME); \
	export APP_PROJECT_PATH=$(APP_PROJECT_PATH); \
	export APP_BUNDLE_ID=$(APP_BUNDLE_ID); \
	export APPLE_TEAM_ID=$(APPLE_TEAM_ID); \
	export APP_STORE_CONNECT_API_KEY_BASE64="$$(base64 < Signing/AppStoreConnect.p8 | tr -d '\n')"; \
	fastlane ios testflight

# Development workflow
.PHONY: setup
setup: update-schema generate-apollo ## Complete setup: fetch schema and generate code
	@echo "✓ Setup complete!"
	@echo "Next steps:"
	@echo "1. Open TicketScannerApp/TicketScannerApp.xcodeproj in Xcode"
	@echo "2. Build and run the app"

.PHONY: dev
dev: update-schema generate-apollo ## Development workflow: update schema and regenerate code
	@echo "Development update complete!"

# Validation
.PHONY: validate-schema
validate-schema: ## Validate GraphQL schema file exists
	@echo "Validating GraphQL schema..."
	@if [ ! -f $(SCHEMA_FILE) ]; then \
		echo "Error: $(SCHEMA_FILE) not found"; \
		exit 1; \
	fi
	@echo "Schema file exists: $(SCHEMA_FILE)"

.PHONY: validate-operations
validate-operations: ## Validate GraphQL operations exist
	@echo "Validating GraphQL operations..."
	@if [ ! -d "GraphQL/Operations" ]; then \
		echo "Error: GraphQL/Operations directory not found"; \
		exit 1; \
	fi
	@if [ -z "$$(find GraphQL/Operations -name '*.graphql' -type f)" ]; then \
		echo "Error: No .graphql files found in GraphQL/Operations"; \
		exit 1; \
	fi
	@echo "GraphQL operations validation passed"

# Documentation
.PHONY: docs
docs: ## Generate basic documentation
	@echo "Generating documentation..."
	@mkdir -p docs
	@echo "# GraphQL Schema" > docs/schema.md
	@echo "" >> docs/schema.md
	@echo "This document contains the GraphQL schema for the Ticket Scanner app." >> docs/schema.md
	@echo "" >> docs/schema.md
	@if [ -f $(SCHEMA_FILE) ]; then \
		echo "\`\`\`graphql" >> docs/schema.md; \
		cat $(SCHEMA_FILE) >> docs/schema.md; \
		echo "\`\`\`" >> docs/schema.md; \
	fi
	@echo "Documentation generated in docs/schema.md"

# Status check
.PHONY: status
status: ## Check project status
	@echo "Project Status:"
	@echo "==============="
	@echo "Backend URL: $(BACKEND_URL)"
	@echo "Schema file: $(SCHEMA_FILE) $$(if [ -f $(SCHEMA_FILE) ]; then echo '(exists)'; else echo '(missing)'; fi)"
	@echo "Generated dir: $(GENERATED_DIR) $$(if [ -d $(GENERATED_DIR) ]; then echo '(exists)'; else echo '(missing)'; fi)"
	@echo "GraphQL operations: $$(find GraphQL/Operations -name '*.graphql' -type f 2>/dev/null | wc -l | tr -d ' ') files"
	@echo "Dependencies:"
	@command -v curl >/dev/null 2>&1 && echo "  ✓ curl" || echo "  ✗ curl"
	@command -v jq >/dev/null 2>&1 && echo "  ✓ jq" || echo "  ✗ jq"
	@command -v apollo >/dev/null 2>&1 && echo "  ✓ apollo" || echo "  ✗ apollo (optional)"

# Cleanup
.PHONY: clean
clean: clean-generated clean-ios ## Clean all generated files
	@echo "Cleaning all generated files..."
	@rm -f schema.json
	@echo "Clean complete"

.PHONY: clean-all
clean-all: clean ## Clean everything
	@echo "Cleaning everything..."
	@echo "Complete clean finished"
