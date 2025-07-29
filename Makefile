SHELL:=/bin/bash

.DEFAULT_GOAL := all

ROOT_DIR:=$(shell dirname "$(realpath $(firstword $(MAKEFILE_LIST)))")

.EXPORT_ALL_VARIABLES:
DOCKER_BUILDKIT?=1
DOCKER_CONFIG?=

USER := $(shell whoami)
UID := $(shell id -u)
GID := $(shell id -g)



ROS_DISTRO?=jazzy
ROS_PACKAGE_NAME?=hello_world
ROS_NODE_NAME?=hello_world

.PHONY: help
help:
	@printf "Usage: make \033[36m<target>\033[0m\n%s\n" "$$(awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*?##/ { gsub(/\\$$/, "", $$2); printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST) | sort | uniq | sed 's/\$$//' | sed 's/\\$$//' )"


.PHONY: build
build: clean ## Build the docker service
	mkdir -p ros2_ws/log
	docker compose build --build-arg UID=${UID} \
                         --build-arg GID=${GID} \
                         --build-arg ROS_DISTRO=${ROS_DISTRO}

.PHONY: start
start: build ## Start the docker service
	docker compose rm -f || true
	mkdir -p ros2_ws/log 
	docker compose up -d --force-recreate

.PHONY: stop
stop: ## Stop the docker service
	docker compose down
	docker compose rm --stop --force || true

.PHONY: logs
logs: ## Show/follow stdio of service 
	docker compose logs -f

.PHONY: attach
attach: ## Attach interactive session
	docker compose exec ros2_service /bin/bash

.PHONY: debug
debug: ## Attach to stdio of docker service as root 
	docker compose exec -u root ros2_service /bin/bash


.PHONY: clean
clean: ## Clean project (rmove .log directory, remove docker images)
	docker compose rm --stop --force || true
	rm -rf ros2_ws/log
	docker compose down --volumes --remove-orphans
	docker image prune -f

