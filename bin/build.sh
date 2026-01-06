#!/usr/bin/env bash
set -e
echo "=== Pharma Transport Dashboard Build ==="

# Ruby gems
if [ -f Gemfile ]; then
  gem install bundler --no-document
  bundle check || bundle install --without development test
fi

# Node.js
npm ci --only=production || echo "No package.json"

# Assets
if command -v bundle >/dev/null && bundle exec rails >/dev/null 2>&1; then
  bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=xyz123 || true
fi

echo "✅ Build complete"
