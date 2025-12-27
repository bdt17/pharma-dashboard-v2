#!/usr/bin/env bash
set -e

echo "Precompiling assets..."
rm -rf public/assets tmp/cache
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails assets:clobber
echo "✅ Rails 8 pharma dashboard ready"
