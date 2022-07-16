.DEFAUL_GOAL=help

GOTESTCMD := go test -race

## help: List available build targets and descriptions
help: Makefile
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'

## dev: Start the app in development mode
.PHONY: dev
dev:
	air

## start: Start the app in production mode
.PHONY: start
start:
	go run ./cmd/app/main.go

## test: Run all tests
.PHONY: test test/unit cover/unit
test: test/unit

## test/unit: Run all unit tests
test/unit:
	@$(GOTESTCMD) $(COVERPROFILE) ./...

## test/cover: Run coverage
test/unit/cover: COVERPROFILE=-coverprofile coverage.out
test/unit/cover: test/unit
	@go tool cover -html=coverage.out -o coverage.html
