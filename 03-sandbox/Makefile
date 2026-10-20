# Makefile de la feature 001-nginx.
# `make wise` es destructivo y elimina SOLO recursos de esta feature.
# No toca la imagen base de Nginx, otros proyectos, .env, README ni specs.

SHELL := /bin/sh

PROJECT ?= $(notdir $(CURDIR))
CONTAINER ?= 03-nginx
IMAGE ?= 03-nginx-image:01
NETWORK ?= $(PROJECT)_default
# Directorios host usados como volúmenes por el compose de la feature.
VOLUME_DIRS := vol-01-nginx-conf.d vol-01-nginx-logs vol-01-nginx-web

.DEFAULT_GOAL := help

.PHONY: help wise

help:
	@echo "Objetivos:"
	@echo "  make wise   Elimina contenedor, imagen, red, volúmenes y archivos de 001-nginx (destructivo)."

wise:
	@echo "ADVERTENCIA: eliminando los recursos de la feature 001-nginx."
	-@docker compose -p $(PROJECT) down --remove-orphans
	-@docker container ls -aq --filter "label=com.docker.compose.project=$(PROJECT)" --filter "label=com.docker.compose.project.working_dir=$(CURDIR)" | xargs -r docker rm -f
	-@docker rm -f $(CONTAINER) >/dev/null 2>&1 || true
	-@docker volume ls -q --filter "label=com.docker.compose.project=$(PROJECT)" --filter "label=com.docker.compose.project.working_dir=$(CURDIR)" | xargs -r docker volume rm -f
	-@docker network rm $(NETWORK) >/dev/null 2>&1 || true
	-@docker image rm -f $(IMAGE) >/dev/null 2>&1 || true
	@rm -rf $(VOLUME_DIRS)
	@if [ -d docker ]; then find docker -mindepth 1 -delete; fi
	@rm -f docker-compose.yaml
	@: > docker-compose.yaml
	@echo "Listo: feature 001-nginx eliminada. docker-compose.yaml queda vacío."
