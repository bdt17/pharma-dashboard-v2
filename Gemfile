source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 8.1.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mswin mingw x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
end

gem "pundit", "~> 2.5"

gem "sidekiq", "~> 8.1"

# Phase 11.5: API Authentication
gem "bcrypt", "~> 3.1"

# Phase 12: Enterprise Kubernetes
gem "redis", "~> 5.0"
gem "hiredis-client", "~> 0.22"
gem "prometheus-client", "~> 4.2"
