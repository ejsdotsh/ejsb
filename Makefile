#!/usr/bin/make -f

SHELL := /bin/bash

# https://lithic.tech/blog/2020-05/makefile-dot-env/
ifneq (,$(wildcard ./.env))
	include .env
	export
	ENVFILE_PARAMS = --env-file .env
endif

VERSION := $$(<VERSION)
UID := $$(id -u)
GID := $$(id -g)
NAME := ejsb
DATE := $$(date +%Y%m%d)
BUILD_DATE := $$(date +%F)
CURRENT_DIR := $(CURDIR)

.DEFAULT_GOAL := edit

##@ General

# adapted from: https://www.padok.fr/en/blog/beautiful-makefile-awk
# The help target prints out all targets with their descriptions organized
# beneath their categories.

.PHONY: help
help: ## display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\033[0m\n  make <target>\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } /^##@/ { printf "\n\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: image-clean
image-clean: ## maintenance command to remove intermediate containers
	@podman rmi $$(podman images -f "dangling=true" -q)

##@ Build

.PHONY: build
build: ## this hasn't been implemented yet
	@echo "this hasn't been implemented yet"

##@ Development

.PHONY: edit
edit: ## create a dated branch and open vscode
	git checkout -b $(DATE)

##@ Testing

.PHONY: testall
testall: ## runs all defined tests
	$(MAKE) test

.PHONY: test
test: ## shows the value of some variables
	@echo ${VERSION}
	@echo ${CURRENT_DIR}
	@echo ${HOME}
	@echo ${BUILD_DATE}
	@echo $(MAKEFILE_LIST)

