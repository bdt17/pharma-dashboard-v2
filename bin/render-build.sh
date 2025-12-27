#!/usr/bin/env bash
set -e

bundle config set --local without 'development test'
bundle install

# Create/provision DB if needed, then migrate
bin/rails db:create
bin/rails db:migrate
