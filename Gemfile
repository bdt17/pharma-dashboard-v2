source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 8.1.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "tzinfo-data", platforms: [:windows, :jruby]
gem "bootsnap", require: false
gem "bootstrap", "~> 5.3.0"
gem "sassc-rails"

# FDA Compliance + Auth (Phase 6) - SINGLE INSTANCES ONLY
gem 'devise'                    # User auth + 21 CFR Part 11 user tracking
gem 'pundit'                    # Authorization for DEA controlled substances
gem 'audited'                   # Automatic 21 CFR Part 11 audit trails
gem 'docusign_esign'            # Electronic signatures
gem 'redis', '~> 5.0'           # ActionCable for live sensor streams (ONE version)
gem 'httparty'                  # NIST sensor API integration
gem 'stripe'                    # Payments
gem 'twilio-ruby'               # SMS alerts

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end
gem 'docusign_esign'
gem 'redis', '~> 5.0'
gem 'web-console', group: :development
