# Fighters Program — infrastructure

Development environment and demo database of Fighters Program. The game itself lives in the sibling repositories:

```
laboratorio_integrato_its/
├── gruppo-06-fighters_program-backend
├── gruppo-06-fighters_program-frontend
└── gruppo-06-fighters_program-infrastructure   ← this one
```

## Requirements

- Docker **or** Podman (the script uses whichever it finds)
- Java 25 (the backend runs with its Maven wrapper) and Node.js 24 (the frontend)
- `python3`, `curl`, `openssl`, `ss` (standard on Linux)

## Start everything

```bash
cp .env.example .env        # optional: change ports, admin account, paths
scripts/dev.sh start
```

It starts Postgres 17 and Redis 7 in containers, then the backend (`http://localhost:8080`, Swagger at
`/swagger-ui.html`) and the frontend (`http://localhost:5173/app`), and creates the demo players.
The first start compiles the backend and takes a few minutes.

| Command | What it does |
|---|---|
| `scripts/dev.sh start` | Start containers, backend and frontend, then seed the demo data |
| `scripts/dev.sh stop` | Stop backend, frontend and containers (data kept) |
| `scripts/dev.sh reset` | Stop and delete the database volume and the local state |
| `scripts/dev.sh seed` | Create the demo data through the API (skips what already exists) |
| `scripts/dev.sh db:restore` | Load `database/demo/fighters-demo.sql` into the database and start |
| `scripts/dev.sh db:dump` | Rewrite `database/demo/fighters-demo.sql` from the running database |

Logs and local state (generated JWT key, card illustrations) are in `~/.local/share/fighters-dev/`.
`compose.yaml` describes the same database and cache if you prefer `docker compose up -d`.

## Demo data

| Player | Email | Deck |
|---|---|---|
| sara | `sara@fighters.demo` | Furia del Sud (Africana), best sub-cards per class |
| marco | `marco@fighters.demo` | Muro d'Acciaio (Eurasiatica), alternative sub-cards |
| giulia | `giulia@fighters.demo` | Vento dell'Ovest (Panamericana) |
| luca | `luca@fighters.demo` | Lama d'Oriente (Euroatlantica) |

Password of every demo player: `fighters-demo-1`. The seed also plays three matches (one base, two advanced) and
leaves a pending friend request from sara to marco. The admin account is created only if `ADMIN_PASSWORD` is set in
`.env`.

`database/demo/fighters-demo.sql` is a full dump (schema, data and Flyway history) of that seeded database, so the
team and the final delivery start from the same state.

> **Demo only.** The dump contains the password hashes of the demo accounts, whose password is public. Never load it
> into a production database.

## When the backend adds a migration

The dump is tied to the migrations it contains. After a new `V<n>__*.sql` is merged in the backend:

```bash
scripts/dev.sh reset && scripts/dev.sh start   # fresh database migrated to the latest version + seed
scripts/dev.sh db:dump                         # refresh the versioned dump
```

and commit the new `database/demo/fighters-demo.sql`. Loading an old dump into a newer backend also works: Flyway
applies the missing migrations at startup.

## Notes

- Tests of the backend must never point at this database (port 5432 by default): they leave test users behind.
  Use another database or port for them.
- The advanced mode is enabled by default here (`GAME_ADVANCED_ENABLED=true`); in the backend it is off unless set.
