#!/usr/bin/env bash
set -e
bundle install --without development test
rm -rf public/assets tmp/cache
mkdir -p public/assets tmp/cache
RAILS_ENV=production bundle exec rails assets:precompile
echo "✅ Pharma dashboards ready!"
