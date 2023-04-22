SHELL=/bin/bash

env := $(shell docker compose exec node echo "up" || echo "down")

init:
	@docker compose build

up:
	@docker compose up

down:
	@docker compose down

exec:
	@docker compose exec node sh

yarn-install:
	@[ $(env) = "down" ] && docker compose up -d || echo "uped"
	@docker compose exec node yarn install
	@docker compose exec node echo "copy node_modules files from container"
	docker cp docker-node-practice:/home/app/node_modules/ ./front/
	@[ $(env) = "down" ] && docker compose down || echo "installed"
