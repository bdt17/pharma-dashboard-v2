# FDA 21 CFR Part 11 Compliant Production Configuration
# Phase 12: Enterprise Kubernetes Deployment

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for 1 year (fingerprinted assets)
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}",
    "X-Content-Type-Options" => "nosniff"
  }

  # Store files on local disk or S3 in production.
  config.active_storage.service = ENV.fetch("STORAGE_SERVICE", "local").to_sym

  # ═══════════════════════════════════════════════════════════════════════════
  # FDA 21 CFR Part 11 SECURITY CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  # Force all access to the app over SSL
  config.force_ssl = true
  config.ssl_options = {
    redirect: { exclude: ->(request) { request.path.start_with?("/health") } },
    hsts: { subdomains: true, preload: true, expires: 1.year }
  }

  # Security headers
  config.action_dispatch.default_headers = {
    "X-Frame-Options" => "DENY",
    "X-Content-Type-Options" => "nosniff",
    "X-XSS-Protection" => "1; mode=block",
    "Referrer-Policy" => "strict-origin-when-cross-origin",
    "Permissions-Policy" => "geolocation=(), microphone=(), camera=()"
  }

  # ═══════════════════════════════════════════════════════════════════════════
  # LOGGING - FDA Audit Trail Support
  # ═══════════════════════════════════════════════════════════════════════════

  # Log to STDOUT for container environments (Kubernetes)
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Log level (info in production, can be overridden via LOG_LEVEL env)
  config.log_level = ENV.fetch("LOG_LEVEL", "info").to_sym

  # Include request_id in logs for audit trail correlation
  config.log_tags = [:request_id]

  # Use JSON formatter for structured logging (ELK/CloudWatch compatible)
  if ENV["LOG_FORMAT"] == "json"
    config.logger.formatter = proc do |severity, time, progname, msg|
      {
        timestamp: time.iso8601,
        severity: severity,
        message: msg,
        service: "pharma-transport"
      }.to_json + "\n"
    end
  end

  # Prepend all log lines with tags for FDA compliance tracking
  config.active_record.query_log_tags_enabled = true
  config.active_record.query_log_tags = [
    :application,
    :controller,
    :action,
    :request_id
  ]

  # ═══════════════════════════════════════════════════════════════════════════
  # CACHING - Redis for High Availability
  # ═══════════════════════════════════════════════════════════════════════════

  config.cache_store = :redis_cache_store, {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    namespace: "pharma_cache",
    expires_in: 1.hour,
    race_condition_ttl: 10.seconds,
    error_handler: ->(method:, returning:, exception:) {
      Rails.logger.error("Redis cache error: #{exception.message}")
      Sentry.capture_exception(exception) if defined?(Sentry)
    }
  }

  # ═══════════════════════════════════════════════════════════════════════════
  # ACTION CABLE - Real-time GPS Streaming
  # ═══════════════════════════════════════════════════════════════════════════

  # Mount Action Cable outside main process or use async adapter.
  config.action_cable.mount_path = "/cable"
  config.action_cable.url = ENV.fetch("ACTION_CABLE_URL", nil)
  config.action_cable.allowed_request_origins = [
    ENV.fetch("ALLOWED_ORIGIN", "https://pharmatransport.io"),
    /https:\/\/.*\.pharmatransport\.io/
  ]

  # Disable Action Cable CSRF protection for API clients
  config.action_cable.disable_request_forgery_protection = true

  # ═══════════════════════════════════════════════════════════════════════════
  # EMAIL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: ENV.fetch("MAILER_HOST", "pharmatransport.io"),
    protocol: "https"
  }

  # ═══════════════════════════════════════════════════════════════════════════
  # ACTIVE RECORD - Database Configuration
  # ═══════════════════════════════════════════════════════════════════════════

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Use SQL schema format for complex constraints
  config.active_record.schema_format = :sql

  # Enable automatic connection switching for read replicas
  config.active_record.database_selector = { delay: 2.seconds }
  config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

  # ═══════════════════════════════════════════════════════════════════════════
  # ACTIVE JOB - Background Processing
  # ═══════════════════════════════════════════════════════════════════════════

  config.active_job.queue_adapter = :sidekiq

  # ═══════════════════════════════════════════════════════════════════════════
  # I18N / DEPRECATIONS
  # ═══════════════════════════════════════════════════════════════════════════

  # Enable locale fallbacks for I18n
  config.i18n.fallbacks = true

  # Don't log any deprecations (we've already handled them)
  config.active_support.report_deprecations = false

  # ═══════════════════════════════════════════════════════════════════════════
  # STATIC FILES (only when RAILS_SERVE_STATIC_FILES is set)
  # ═══════════════════════════════════════════════════════════════════════════

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # ═══════════════════════════════════════════════════════════════════════════
  # ASSETS
  # ═══════════════════════════════════════════════════════════════════════════

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false if config.respond_to?(:assets)

  # ═══════════════════════════════════════════════════════════════════════════
  # SESSION SECURITY - FDA 21 CFR Part 11 Access Controls
  # ═══════════════════════════════════════════════════════════════════════════

  config.session_store :cookie_store,
    key: "_pharma_session",
    secure: true,
    httponly: true,
    same_site: :strict,
    expire_after: 30.minutes
end
