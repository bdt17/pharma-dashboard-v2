#!/usr/bin/env bash
set -e

# Install Ruby gems (if Gemfile exists)
if [ -f Gemfile ]; then
  gem install bundler
  bundle install
fi

# Install Node.js dependencies
if [ -f package.json ]; then
  npm ci --only=production
fi

# Precompile assets (if Rails)
if [ -f bin/rails ]; then
  bundle exec rails assets:precompile RAILS_ENV=production
fi

# Build dashboard frontend
npm run build || echo "No frontend build needed"
