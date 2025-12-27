#!/usr/bin/env bash
set -e
bundle install --without development test
rm -rf public/assets tmp/cache
RAILS_ENV=production bundle exec rails assets:precompile
echo "✅ Rails 8 pharma dashboard ready"
