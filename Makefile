#!/usr/bin/make -f

SHELL := /bin/bash

include .env

VERSION := $$(<VERSION)
UID := $$(id -u)
GID := $$(id -g)
NAME := nod
BUILD_DATE := $$(date +%F)
CURRENT_DIR := $(CURDIR)

##@ General

# adapted from: https://www.padok.fr/en/blog/beautiful-makefile-awk
# The help target prints out all targets with their descriptions organized
# beneath their categories.

.PHONY: help
help: ## display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: image-clean
image-clean: ## maintenance command to remove intermediate containers
	@docker rmi $$(docker images -f "dangling=true" -q)

.PHONY: test
test: ## shows the value of some variables
	@echo ${VERSION}
	@echo ${CURRENT_DIR}
	@echo ${HOME}
	@echo ${BUILD_DATE}
	@echo $(MAKEFILE_LIST)


##@ Build

.PHONY: nodpy
nodpy: ## build the FastAPI+Nornir container
	@docker build --force-rm \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg BUILD_VERSION=${VERSION} \
		--build-arg NOD_USER=${NOD_USER} \
		--file be/nr/Dockerfile \
		-t "joshuaejs/nodpy:${VERSION}" \
		-t "nodpy:latest" be/nr

#		--build-arg NOD_UID=${UID} \
#		--build-arg NOD_GID=${GID} \

.PHONY: nodgo
nodgo: ## build the net/http+Gornir container
	@docker build --force-rm \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg BUILD_VERSION=${VERSION} \
		--build-arg NOD_USER=${NOD_USER} \
		--file be/gr/Dockerfile \
		-t "joshuaejs/nodgo:${VERSION}" \
		-t "nodgo:latest" be/gr

.PHONY: nodbe
nodbe: nodgo nodpy ## meta-target to build both backends

.PHONY: nod
nod: nodbe ## meta-target to build everything


##@ Development

.PHONY: pydev
pydev: nodpy ## build and attach to the FastAPI+Nornir container
	@if [ -z $$(docker network ls -q -f name=${NAME}) ]; then \
		docker network create ${NAME}; \
	fi

	@docker run -it --rm --gpus all \
		-h ${NAME} \
		--net=${NAME} \
		--name ${NAME} \
		--mount type=bind,src="${CURRENT_DIR}"/inventories,dst=/srv/nod/inventories \
		--mount type=bind,src="${CURRENT_DIR}"/conf,dst=/srv/nod/nr_data \
		--mount type=bind,src="${CURRENT_DIR}"/logs,dst=/srv/nod/logs \
		--mount type=bind,src="${HOME}"/.ssh/"${NOD_USER}",dst=/srv/nod/.ssh \
		--publish 8080:8080 \
		-w /srv/nod \
		nodpy bash
