# Repository Guidelines

This repository manages the Hermes deployment for the Ubuntu home server.

## Server Paths

- Repo checkout: `/home/dodds/hermes`
- Hermes runtime data: `/home/dodds/hermes/data`
- Media stack repo: `/home/dodds/dodds-server`
- Hermes dashboard: `http://192.168.178.37:9119`
- Hermes gateway: `http://192.168.178.37:8642`

## Commands

Run from `/home/dodds/hermes` on the Ubuntu server:

```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs --tail=100 hermes
```

Admin mode is opt-in only:

```bash
docker compose -f docker-compose.yml -f docker-compose.admin.yml config
docker compose -f docker-compose.yml -f docker-compose.admin.yml up -d
```

## Safety Notes

- Do not enable `docker-compose.admin.yml` unless the user explicitly wants Hermes to administer Docker apps.
- Treat `/var/run/docker.sock` access as host-admin access.
- Do not commit `.env` or anything under `data/`.
- Keep LAN exposure at `192.168.178.37` unless the user asks to switch back to localhost-only access.
- Keep media-stack admin actions constrained to scripts in `scripts/` where possible.
