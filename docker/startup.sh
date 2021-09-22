#!/bin/bash

set -e

./docker/prepare-db.sh

if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

exec "$@"