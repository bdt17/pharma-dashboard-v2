#!/usr/bin/env bash
set -e

bundle config set --local without 'development test'
bundle install

# Rails 8 Render: Safe migration (skip duplicates)
bin/rails db:migrate:status || true
bin/rails db:migrate
