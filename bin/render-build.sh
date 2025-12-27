#!/usr/bin/env bash
bundle config set without 'development test'
bundle install
bundle exec rails assets:precompile
