# Hermes

Separate Docker Compose app for running Hermes on the home server.

The default compose file does not grant Hermes access to the host Docker socket. This keeps Hermes isolated from the media stack unless Docker administration is explicitly enabled.

## Ubuntu Server Setup

This repo is intended to be cloned on the Ubuntu server, for example:

```text
/home/dodds/hermes
/home/dodds/dodds-server
```

From the Ubuntu server:

```bash
cd /home/dodds/hermes
cp .env.example .env
mkdir -p /home/dodds/hermes/data
docker compose up -d
```

Default LAN bindings:

- Gateway: `192.168.178.37:8642`
- Dashboard: `192.168.178.37:9119`

To keep Hermes local-only instead, edit `.env`:

```env
HERMES_GATEWAY_BIND=127.0.0.1
HERMES_DASHBOARD_BIND=127.0.0.1
```

Hermes runtime data is stored in:

```text
/home/dodds/hermes/data
```

## Docker Admin Mode

Only enable this if you want Hermes to administer Docker apps on the host.

```bash
cd /home/dodds/hermes
docker compose -f docker-compose.yml -f docker-compose.admin.yml up -d
```

The admin override builds a local image from `Dockerfile.admin` so the Hermes container has the Docker and Docker Compose CLI available for the helper scripts.

This mounts:

- `/var/run/docker.sock` into the Hermes container
- `${MEDIA_REPO_PATH}` at `/workspace/dodds-server`

With this override enabled, Hermes can run the scripts in `/opt/hermes-admin` to restart or update the media stack.

Mounting the Docker socket gives Hermes root-equivalent control of the host through Docker. Keep it off unless you intentionally want that.

## Media Admin Scripts

Scripts are mounted read-only into the container at `/opt/hermes-admin`.

```bash
/opt/hermes-admin/media-status.sh
/opt/hermes-admin/media-restart.sh jellyfin
/opt/hermes-admin/media-update.sh
```

The scripts expect `MEDIA_COMPOSE_FILE` to point at the media compose file. The admin override sets:

```env
MEDIA_COMPOSE_FILE=/workspace/dodds-server/docker-compose.yml
```

If the media repo lives somewhere else on the server, set `MEDIA_REPO_PATH` in `.env`.

For example:

```env
MEDIA_REPO_PATH=/home/dodds/dodds-server
```
