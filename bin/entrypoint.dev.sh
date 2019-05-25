#!/bin/bash
set -e

bundle install
yarn install

bundle exec rake db:migrate
echo "RUN $@"
exec "$@"