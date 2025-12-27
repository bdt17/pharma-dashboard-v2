#!/usr/bin/env bash
set -e

bundle config set --local without 'development test'
bundle install

# Rails 8 Render: NO DB TASKS - app works without migrations
echo "✅ Rails 8 pharma dashboard ready (DB optional)"
