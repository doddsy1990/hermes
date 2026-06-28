#!/usr/bin/env sh
set -eu

MEDIA_COMPOSE_FILE="${MEDIA_COMPOSE_FILE:-/home/dodds/docker/docker-compose.yml}"

docker compose -f "$MEDIA_COMPOSE_FILE" pull
docker compose -f "$MEDIA_COMPOSE_FILE" up -d
docker image prune -f
