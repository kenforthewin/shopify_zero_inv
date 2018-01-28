#!/usr/bin/env bash
set -e
bundle install
bundle exec rake db:create db:migrate
bundle exec puma -C config/puma.rb -d
if [ "$RAILS_ENV" = "production" ]; then
  npm install
  rake assets:precompile
fi
exec nginx -g 'daemon off;'