# Local Postgres

One Postgres 17 server container for the local Octopus demo. Dev, Test, and Production each get their own database and login role on this server.

## Start the server

1. Copy the example settings: `cp .env.example .env`
2. Open `.env` and replace `change-me` with a real admin password.
3. Start the container: `docker compose up -d`
4. Confirm it is healthy: `docker compose ps` shows `healthy` after about 10 seconds.

## Connection details

- Host: `localhost` from your Mac, `host.docker.internal` from other containers
- Port: `5432`
- Admin user: the value of `POSTGRES_ADMIN_USER`

## Stop and reset

- Stop, keep data: `docker compose down`
- Stop and delete all data: `docker compose down -v`
