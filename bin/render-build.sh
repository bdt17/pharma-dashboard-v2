#!/usr/bin/env bash
set -e

bundle config set --local without 'development test'
bundle install

# Skip migrations until config/database.yml fixed
echo "✅ Build complete - skipping migrations (Rails 8 multi-DB config needed)"
