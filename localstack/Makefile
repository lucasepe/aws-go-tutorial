.DEFAULT_GOAL := help
.PHONY: help start start-detach stop logs

FLAGS := --env-file $${HOME}/.localstack/.env

## start: Starts Localstack
start:
	docker-compose $(FLAGS) up

## startd: Starts Localstack in detached mode
startd:
	docker-compose $(FLAGS) up -d

## stop: Stops Localstack
stop:
	docker-compose $(FLAGS) down

## logs: Collect Localstack docker logs
logs:
	docker-compose $(FLAGS) logs

## help: This help
help: Makefile
	@echo
	@echo " Choose a command run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
