#!/usr/bin/env bash
set -e
bundle config set --local without 'development test'
bundle install
bin/rails db:migrate
