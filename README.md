# Hermes

Separate Docker Compose app for running Hermes on the home server.

The default compose file does not grant Hermes access to the host Docker socket. This keeps Hermes isolated from the media stack unless Docker administration is explicitly enabled.

## Ubuntu Server Setup

This repo is intended to be cloned on the Ubuntu server, for example:

```text
/home/dodds/hermes
/home/dodds/docker
```

From the Ubuntu server:

```bash
cd /home/dodds/hermes
cp .env.example .env
mkdir -p /home/dodds/hermes/data
docker compose up -d
```

## Git Push SSH Setup

Hermes uses a read-only SSH directory mounted from the host at `/opt/hermes-ssh`.
By default the host path is:

```text
/home/dodds/hermes-secrets/ssh
```

Create it on the Ubuntu server and copy in the deploy key Hermes should use for
Git pushes:

```bash
install -d -m 755 /home/dodds/hermes-secrets
install -d -m 755 /home/dodds/hermes-secrets/ssh
install -m 600 ~/.ssh/id_ed25519 /home/dodds/hermes-secrets/ssh/id_ed25519
ssh-keyscan github.com > /home/dodds/hermes-secrets/ssh/known_hosts
chmod 644 /home/dodds/hermes-secrets/ssh/known_hosts
```

For unattended pushes, the deploy key must not require a passphrase. Confirm the
mounted private key can print its public key without prompting:

```bash
ssh-keygen -y -f /home/dodds/hermes-secrets/ssh/id_ed25519
```

If it prompts for a passphrase, either remove the passphrase from that deploy key
or regenerate it:

```bash
ssh-keygen -p -f /home/dodds/hermes-secrets/ssh/id_ed25519 -N ""
```

If the key lives somewhere else, set `HERMES_SSH_PATH` in `.env`.

After changing SSH files, restart Hermes:

```bash
docker compose up -d
```

If pushes fail with `Permission denied` for `/opt/hermes-ssh/id_ed25519` or
`/opt/hermes-ssh/known_hosts`, check that the host directories are searchable
by the container:

```bash
namei -l /home/dodds/hermes-secrets/ssh/id_ed25519
docker compose exec hermes ls -la /opt/hermes-ssh
docker compose exec hermes ssh -i /opt/hermes-ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes -o UserKnownHostsFile=/opt/hermes-ssh/known_hosts -T git@github.com
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
- `${MEDIA_REPO_PATH}` at `/home/dodds/docker`

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
MEDIA_COMPOSE_FILE=/home/dodds/docker/docker-compose.yml
```

If the media repo lives somewhere else on the server, set `MEDIA_REPO_PATH` in `.env`.

For example:

```env
MEDIA_REPO_PATH=/home/dodds/docker
```
