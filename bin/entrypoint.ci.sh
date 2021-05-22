#!/bin/bash
set -e

bundle install
yarn install

rm -f tmp/pids/server.pid

echo "RUN" "$@"
exec "$@"
