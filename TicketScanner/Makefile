# Ticket Scanner Makefile

# Configuration
BACKEND_URL = http://localhost:8080
SCHEMA_FILE = schema.graphqls
GENERATED_DIR = Generated
INTROSPECTION_QUERY = '{"query":"query IntrospectionQuery { __schema { queryType { name } mutationType { name } subscriptionType { name } types { ...FullType } directives { name description locations args { ...InputValue } } } } fragment FullType on __Type { kind name description fields(includeDeprecated: true) { name description args { ...InputValue } type { ...TypeRef } isDeprecated deprecationReason } inputFields { ...InputValue } interfaces { ...TypeRef } enumValues(includeDeprecated: true) { name description isDeprecated deprecationReason } possibleTypes { ...TypeRef } } fragment InputValue on __InputValue { name description type { ...TypeRef } defaultValue } fragment TypeRef on __Type { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } } } } }"}'

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
.PHONY: fetch-schema
fetch-schema: check-deps ## Fetch GraphQL schema from localhost backend
	@echo "Fetching GraphQL schema from $(BACKEND_URL)/graphql..."
	@curl -s -X POST \
		-H "Content-Type: application/json" \
		-d $(INTROSPECTION_QUERY) \
		$(BACKEND_URL)/graphql \
		| jq '.data.__schema' > schema.json
	@if [ $$? -eq 0 ]; then \
		echo "Schema fetched and saved to schema.json"; \
	else \
		echo "Error: Failed to fetch schema. Is the backend running?"; \
		exit 1; \
	fi

.PHONY: update-schema
update-schema: fetch-schema ## Fetch schema from backend
	@echo "Schema updated! Remember to manually update $(SCHEMA_FILE) if needed."

# Code generation
.PHONY: generate-apollo
generate-apollo: ## Generate Apollo code from GraphQL operations
	@echo "Generating Apollo code..."
	@if [ ! -f $(SCHEMA_FILE) ]; then \
		echo "Error: $(SCHEMA_FILE) not found. Please create it manually or run 'make update-schema'"; \
		exit 1; \
	fi
	@mkdir -p $(GENERATED_DIR)
	@echo "Apollo code generation requires manual setup:"
	@echo "1. Install Apollo CLI: npm install -g @apollo/rover"
	@echo "2. Run: apollo codegen generate --config apollo-codegen-config.json --output $(GENERATED_DIR)/"
	@echo "Generated directory structure created at $(GENERATED_DIR)/"

.PHONY: generate-apollo-manual
generate-apollo-manual: ## Manually generate Apollo code (requires Apollo CLI)
	@echo "Manually generating Apollo code..."
	@command -v apollo >/dev/null 2>&1 || { echo "Error: Apollo CLI not found. Install with: npm install -g @apollo/rover"; exit 1; }
	@apollo codegen generate \
		--config apollo-codegen-config.json \
		--output $(GENERATED_DIR)/
	@echo "Apollo code generated in $(GENERATED_DIR)/"

.PHONY: clean-generated
clean-generated: ## Clean generated Apollo code
	@echo "Cleaning generated code..."
	@rm -rf $(GENERATED_DIR)/
	@echo "Generated code cleaned"

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

# Development workflow
.PHONY: setup
setup: check-deps update-schema ## Complete setup: check deps, fetch schema
	@echo "Setup complete! Next steps:"
	@echo "1. Manually update $(SCHEMA_FILE) if needed"
	@echo "2. Install Apollo CLI: npm install -g @apollo/rover"
	@echo "3. Run: make generate-apollo-manual"

.PHONY: dev
dev: update-schema ## Development workflow: update schema
	@echo "Development update complete!"

# Watch mode for development
.PHONY: watch-schema
watch-schema: ## Watch for schema changes
	@echo "Watching for schema changes..."
	@while true; do \
		make update-schema; \
		echo "Waiting for changes..."; \
		sleep 30; \
	done

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
