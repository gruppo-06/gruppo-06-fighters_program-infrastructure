#!/usr/bin/env bash
# Development environment of Fighters Program: Postgres and Redis in containers (Docker or Podman),
# backend and frontend run from the sibling repositories.
#
#   scripts/dev.sh start        start everything and seed the demo players
#   scripts/dev.sh stop         stop backend, frontend and containers (data kept)
#   scripts/dev.sh reset        stop and delete the database volume and local state
#   scripts/dev.sh seed         (re)create the demo players, decks, matches and friends
#   scripts/dev.sh db:dump      write database/demo/fighters-demo.sql from the running database
#   scripts/dev.sh db:restore   load database/demo/fighters-demo.sql into an empty database and start
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "$ROOT/.env" ]; then
  set -a
  . "$ROOT/.env"
  set +a
fi

BACKEND_DIR="${BACKEND_DIR:-$ROOT/../gruppo-06-fighters_program-backend}"
FRONTEND_DIR="${FRONTEND_DIR:-$ROOT/../gruppo-06-fighters_program-frontend}"
STATE_DIR="${STATE_DIR:-$HOME/.local/share/fighters-dev}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"
REDIS_PORT="${REDIS_PORT:-6379}"
API_URL="http://localhost:8080/api"
DUMP="$ROOT/database/demo/fighters-demo.sql"
PG=fighters-dev-pg
REDIS=fighters-dev-redis

if command -v docker >/dev/null 2>&1; then ENGINE=docker; elif command -v podman >/dev/null 2>&1; then ENGINE=podman
else echo "Serve Docker o Podman"; exit 1; fi

mkdir -p "$STATE_DIR"

exists() { $ENGINE container inspect "$1" >/dev/null 2>&1; }

containers_up() {
  exists $PG || $ENGINE create --name $PG -p "$POSTGRES_PORT:5432" \
    -e POSTGRES_DB=fighters -e POSTGRES_USER=fighters -e POSTGRES_PASSWORD=fighters \
    -v fighters-dev-pg:/var/lib/postgresql/data docker.io/library/postgres:17 >/dev/null
  exists $REDIS || $ENGINE create --name $REDIS -p "$REDIS_PORT:6379" docker.io/library/redis:7 >/dev/null
  $ENGINE start $PG $REDIS >/dev/null
  # -h localhost: during the first initialisation the temporary server only listens on the Unix socket
  until $ENGINE exec $PG pg_isready -h localhost -U fighters >/dev/null 2>&1; do sleep 1; done
}

port_pid() { ss -ltnpH "sport = :$1" 2>/dev/null | sed -nE 's/.*pid=([0-9]+).*/\1/p' | head -1; }

backend_up() {
  if curl -sf http://localhost:8080/actuator/health >/dev/null; then return; fi
  echo "Avvio il backend (il primo avvio compila: qualche minuto)..."
  [ -n "${JWT_SECRET:-}" ] || { [ -f "$STATE_DIR/jwt-secret" ] || openssl rand -base64 48 > "$STATE_DIR/jwt-secret"
    JWT_SECRET="$(cat "$STATE_DIR/jwt-secret")"; }
  (cd "$BACKEND_DIR/fighters-program" && \
    JWT_SECRET="$JWT_SECRET" \
    SPRING_DATASOURCE_URL="jdbc:postgresql://localhost:$POSTGRES_PORT/fighters" \
    SPRING_DATA_REDIS_PORT="$REDIS_PORT" \
    CARD_IMAGES_LOCATION="${CARD_IMAGES_LOCATION:-$STATE_DIR/card-images}" \
    GAME_ADVANCED_ENABLED="${GAME_ADVANCED_ENABLED:-true}" \
    ADMIN_EMAIL="${ADMIN_EMAIL:-}" ADMIN_PASSWORD="${ADMIN_PASSWORD:-}" ADMIN_NICKNAME="${ADMIN_NICKNAME:-admin}" \
    setsid nohup sh ./mvnw -q -pl application -am spring-boot:run > "$STATE_DIR/backend.log" 2>&1 &) </dev/null >/dev/null 2>&1
  until curl -sf http://localhost:8080/actuator/health >/dev/null; do
    if grep -q "APPLICATION FAILED\|BUILD FAILURE" "$STATE_DIR/backend.log" 2>/dev/null; then
      echo "Il backend non è partito: vedi $STATE_DIR/backend.log"; exit 1
    fi
    sleep 2
  done
}

frontend_up() {
  if curl -sf http://localhost:5173/app.html >/dev/null; then return; fi
  echo "Avvio il frontend..."
  (cd "$FRONTEND_DIR" && { [ -d node_modules ] || npm ci --no-audit --no-fund; } && \
    VITE_API_URL="${VITE_API_URL:-$API_URL}" setsid nohup npx vite --port 5173 --strictPort \
    > "$STATE_DIR/frontend.log" 2>&1 &) </dev/null >/dev/null 2>&1
  until curl -sf http://localhost:5173/app.html >/dev/null; do sleep 1; done
}

stop_apps() {
  local pid
  for port in 8080 5173; do
    pid=$(port_pid $port)
    [ -n "$pid" ] && kill "$pid" 2>/dev/null || true
  done
  while [ -n "$(port_pid 8080)$(port_pid 5173)" ]; do sleep 1; done
}

seed() { python3 "$ROOT/scripts/seed_demo.py" "$API_URL"; }

case "${1:-start}" in
  start)
    containers_up
    backend_up
    frontend_up
    seed
    echo "Pronto: http://localhost:5173/app  (Swagger: http://localhost:8080/swagger-ui.html)"
    ;;
  stop)
    stop_apps
    $ENGINE stop $PG $REDIS >/dev/null 2>&1 || true
    ;;
  reset)
    stop_apps
    $ENGINE rm -f $PG $REDIS >/dev/null 2>&1 || true
    $ENGINE volume rm fighters-dev-pg >/dev/null 2>&1 || true
    rm -rf "$STATE_DIR"
    ;;
  seed) seed ;;
  db:dump)
    containers_up
    $ENGINE exec $PG pg_dump -U fighters --no-owner --no-privileges fighters > "$DUMP"
    echo "Scritto $DUMP"
    ;;
  db:restore)
    stop_apps
    containers_up
    $ENGINE exec $PG psql -qU fighters -d fighters -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" >/dev/null
    $ENGINE exec -i $PG psql -qU fighters -d fighters -v ON_ERROR_STOP=1 < "$DUMP" >/dev/null
    backend_up
    frontend_up
    echo "Database della demo caricato. Pronto: http://localhost:5173/app"
    ;;
  *) echo "uso: $0 start|stop|reset|seed|db:dump|db:restore"; exit 2 ;;
esac
