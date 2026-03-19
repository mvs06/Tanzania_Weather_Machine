#!/bin/sh
set -eu

cd /var/www/html

if [ ! -f .env ]; then
    cat > .env <<EOF
APP_NAME="${APP_NAME:-Tanzania Weather Machine}"
APP_ENV=${APP_ENV:-production}
APP_KEY=
APP_DEBUG=${APP_DEBUG:-false}
APP_URL=${APP_URL:-http://localhost:${PORT:-8080}}

LOG_CHANNEL=${LOG_CHANNEL:-stack}
LOG_LEVEL=${LOG_LEVEL:-debug}

DB_CONNECTION=${DB_CONNECTION:-sqlite}
DB_DATABASE=${DB_DATABASE:-/var/lib/laravel/database.sqlite}

SESSION_DRIVER=${SESSION_DRIVER:-file}
CACHE_STORE=${CACHE_STORE:-file}
QUEUE_CONNECTION=${QUEUE_CONNECTION:-sync}
EOF
fi

if [ "${DB_CONNECTION:-sqlite}" = "sqlite" ]; then
    DB_FILE="${DB_DATABASE:-/var/lib/laravel/database.sqlite}"
    mkdir -p "$(dirname "$DB_FILE")"
    touch "$DB_FILE"
fi

mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs bootstrap/cache

if [ ! -L public/storage ]; then
    php artisan storage:link --force --no-interaction
fi

if ! grep -Eq '^APP_KEY=.+$' .env; then
    php artisan key:generate --force --no-interaction
fi

if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
    php artisan migrate --force --no-interaction
fi

if [ "$#" -eq 0 ]; then
    exec php artisan serve --host=0.0.0.0 --port="${PORT:-8080}"
fi

exec "$@"
