#!/usr/bin/env sh
set -eu

MEDIA_COMPOSE_FILE="${MEDIA_COMPOSE_FILE:-/workspace/dodds-server/docker-compose.yml}"
SERVICE="${1:-}"

if [ -z "$SERVICE" ]; then
  echo "Usage: $0 <service>" >&2
  echo "Example: $0 jellyfin" >&2
  exit 2
fi

docker compose -f "$MEDIA_COMPOSE_FILE" restart "$SERVICE"
