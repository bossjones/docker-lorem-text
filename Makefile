# -*- coding: utf-8 -*-
# SOURCE: https://github.com/autopilotpattern/jenkins/blob/master/makefile
MAKEFLAGS += --warn-undefined-variables

# SOURCE: https://github.com/luismayta/zsh-servers-functions/blob/b68f34e486d6c4a465703472e499b1c39fe4a26c/Makefile
# Configuration.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
PROJECT_BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
SCRIPT_DIR = $(ROOT_DIR)/script

.PHONY: default build push bash apply delete
CONTAINER_NAME=bossjones/docker-lorem-text

CONTAINER_TAG=$(shell sh -c "grep FROM ./Dockerfile" | awk -F':' '{print $$2}')
DOCKER_BUILD=docker build -t $(CONTAINER_NAME):$(CONTAINER_TAG) .
DOCKER_PUSH=docker push $(CONTAINER_NAME):$(CONTAINER_TAG)

default: build

build:
	$(DOCKER_BUILD)

push:
	$(DOCKER_PUSH)

bash:
	docker run -it --rm $(CONTAINER_NAME):$(CONTAINER_TAG) bash

apply:
	 kubectl --namespace=ns-team-behance-be-net-crons apply -f k8s-crons.yaml

delete:
	 kubectl --namespace=ns-team-behance-be-net-crons delete -f k8s-crons.yaml

cm-apply:
	kubectl --namespace=ns-team-behance-be-net-crons apply -f fluent-bit-configmap.yaml
cm-delete:
	kubectl --namespace=ns-team-behance-be-net-crons delete -f fluent-bit-configmap.yaml
