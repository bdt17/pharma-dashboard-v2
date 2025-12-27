#!/usr/bin/env bash
set -o errexit
bundle install
# Rails 8+ no DB/assets needed for static pharma dashboards
