# Hermes

Separate Docker Compose app for running Hermes on the home server.

The default compose file does not grant Hermes access to the host Docker socket. This keeps Hermes isolated from the media stack unless Docker administration is explicitly enabled.

## Ubuntu Server Setup

This repo is intended to be cloned on the Ubuntu server, for example:

```text
/home/dodds/workspace/hermes
/home/dodds/workspace/dodds-server
```

From the Ubuntu server:

```bash
cd /home/dodds/workspace/hermes
cp .env.example .env
mkdir -p /home/dodds/docker/hermes
docker compose up -d
```

Default bindings:

- Gateway: `127.0.0.1:8642`
- Dashboard: `127.0.0.1:9119`

To expose Hermes on the LAN, edit `.env`:

```env
HERMES_GATEWAY_BIND=192.168.178.37
HERMES_DASHBOARD_BIND=192.168.178.37
```

## Docker Admin Mode

Only enable this if you want Hermes to administer Docker apps on the host.

```bash
cd /home/dodds/workspace/hermes
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

If the repos are not siblings on the server, set `MEDIA_REPO_PATH` in `.env`.

For example:

```env
MEDIA_REPO_PATH=/home/dodds/workspace/dodds-server
```
