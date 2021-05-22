#!/bin/bash
set -e

bundle install
yarn install

rm -f tmp/pids/server.pid

bundle exec rails db:migrate

echo "RUN" "$@"
exec "$@"
