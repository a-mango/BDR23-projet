#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until PGPASSWORD=$POSTGRESQL_PASSWORD psql -h "$host" -U "$POSTGRESQL_USERNAME" -d "$POSTGRESQL_DATABASE" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - starting API"
exec $cmd