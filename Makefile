# Declare all targets as phony (not actual files)
.PHONY: tidy bump-deps generate lint test integration-test clean build all help

# Default target
all: clean tidy lint test build

# Display help information
help:
	@echo "Available targets:"
	@echo "  help             - Show this help message"
	@echo "  tidy             - Run go mod tidy to clean up dependencies"
	@echo "  bump-deps        - Upgrade all dependencies to their latest versions"
	@echo "  generate         - Run code generation tools"
	@echo "  lint             - Run the linter"
	@echo "  test             - Run unit tests with race detector"
	@echo "  integration-test - Run integration tests"
	@echo "  clean            - Clean build artifacts"
	@echo "  build            - Build the sitter-receipt binary"
	@echo "  all              - Run clean, tidy, lint, test, and build"

# Update go.mod and go.sum
tidy:
	go mod tidy

# Update dependencies to latest versions
bump-deps:
	go get -u -t ./...

# Run code generation
generate:
	go generate ./...

# Run linter
lint:
	golangci-lint run

# Run tests with race detection
# Using --count=1 disables test caching
test:
	go test -v -race ./... --count=1

# Run integration tests
integration-test:
	go test -v -race ./... --count=1 --tags=integration

# Clean build artifacts
clean:
	go clean -i ./...
	rm -f sitter-receipt

# Build the binary
build: clean tidy
	go build -o sitter-receipt
