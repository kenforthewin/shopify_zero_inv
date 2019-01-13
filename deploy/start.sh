#!/usr/bin/env bash
set -e
bundle install
bundle exec rake db:create db:migrate
if [ "$RAILS_ENV" = "production" ]; then
  npm install
  rake assets:precompile
fi
bundle exec puma -C config/puma.rb