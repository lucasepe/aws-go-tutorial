.DEFAULT_GOAL := help

.PHONY: help
## help: This help
help: Makefile
	@echo
	@echo " Choose a command run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## start: Starts Localstack
start:
	docker-compose --env-file $(PWD)/.env up -d

## stop: Stops Localstack
stop:
	docker-compose $(PWD)/.env down

## logs: Collect Localstack docker logs
logs:
	docker-compose $(PWD)/.env logs -f localstack
