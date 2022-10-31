#!/usr/bin/make -f

SHELL := /bin/bash

include .env

VERSION := $$(<VERSION)
UID := $$(id -u)
GID := $$(id -g)
NAME := nod
BUILD_DATE := $$(date +%F)
CURRENT_DIR := $(CURDIR)

.PHONY: test
test:
	@echo ${VERSION}
	@echo ${PLAYBOOK_DIR}
	@echo ${CURRENT_DIR}
	@echo ${HOME}
	@echo ${BUILD_DATE}

.PHONY: develop
develop:
	@docker run -it --rm --gpus all \
		-h ${NAME} \
		--name ${NAME} \
		--net=${NAME} \
		--mount type=bind,src="${PLAYBOOK_DIR}"/ansible.cfg,dst=/srv/nod/ansible.cfg,readonly \
		--mount type=bind,src="${PLAYBOOK_DIR}",dst=/srv/nod/ansible \
		--mount type=bind,src="${PLAYBOOK_DIR}"/inventories,dst=/srv/nod/inventories \
		--mount type=bind,src="${HOME}"/.ssh/"${ADMIN_USER}",dst=/srv/nod/.ssh \
		-w /srv/nod \
		nod bash

.PHONY: build
build:
	@docker build --force-rm \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg BUILD_VERSION=${VERSION} \
		--build-arg NOD_UID=${UID} \
		--build-arg NOD_GID=${GID} \
		--build-arg ADMIN_USER=${ADMIN_USER} \
		-t "joshuaejs/nod:${VERSION}" \
		-t "nod:latest" .

.PHONY: build-nc
build-nc:
	@docker build --pull --no-cache --force-rm --squash \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg BUILD_VERSION=${VERSION} \
		--build-arg NOD_UID=${UID} \
		--build-arg NOD_GID=${GID} \
		--build-arg ADMIN_USER=${ADMIN_USER} \
		-t "joshuaejs/nod:${VERSION}" \
		-t "nod:latest" .

.PHONY: image-clean
image-clean:
	@docker rmi $$(docker images -f "dangling=true" -q)
