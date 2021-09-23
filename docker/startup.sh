#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

./docker/prepare-db.sh

exec "$@"