# frozen_string_literal: true

# Kubernetes Health Check Controller
# Phase 12: Enterprise Kubernetes Deployment
#
# Endpoints:
#   GET /health/live    - Liveness probe (is the process running?)
#   GET /health/ready   - Readiness probe (can we accept traffic?)
#   GET /health/detailed - Full health status for monitoring

class HealthController < ApplicationController
  # Skip all authentication and CSRF for health checks
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :authenticate_user!, raise: false if respond_to?(:authenticate_user!)

  # Liveness probe - Kubernetes uses this to know if the container should be restarted
  # Returns 200 if the Ruby process is running
  def live
    render json: {
      status: "ok",
      timestamp: Time.current.iso8601,
      service: "pharma-transport"
    }
  end

  # Readiness probe - Kubernetes uses this to know if the pod can receive traffic
  # Checks critical dependencies (database, Redis)
  def ready
    checks = {
      database: check_database,
      redis: check_redis,
      migrations: check_migrations
    }

    all_healthy = checks.values.all?
    status_code = all_healthy ? :ok : :service_unavailable

    render json: {
      status: all_healthy ? "ready" : "not_ready",
      checks: checks,
      timestamp: Time.current.iso8601
    }, status: status_code
  end

  # Detailed health check for monitoring dashboards (Prometheus, Grafana)
  def detailed
    memory_mb = begin
      `ps -o rss= -p #{Process.pid}`.to_i / 1024
    rescue StandardError
      0
    end

    db_pool = begin
      ActiveRecord::Base.connection_pool.stat
    rescue StandardError
      { error: "unavailable" }
    end

    render json: {
      status: "ok",
      service: "pharma-transport",
      version: ENV.fetch("GIT_SHA", "unknown"),
      environment: Rails.env,
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      timestamp: Time.current.iso8601,
      memory_mb: memory_mb,
      database: {
        pool: db_pool,
        adapter: ActiveRecord::Base.connection.adapter_name
      },
      checks: {
        database: check_database,
        redis: check_redis,
        audit_chain: check_audit_chain
      },
      compliance: {
        audit_logging: true,
        hash_chain_enabled: true,
        ssl_enforced: Rails.configuration.force_ssl
      }
    }
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue StandardError => e
    Rails.logger.error("Health check - Database failed: #{e.message}")
    false
  end

  def check_redis
    redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/1")
    redis = Redis.new(url: redis_url, timeout: 2)
    redis.ping == "PONG"
  rescue StandardError => e
    Rails.logger.error("Health check - Redis failed: #{e.message}")
    false
  ensure
    redis&.close
  end

  def check_migrations
    !ActiveRecord::Base.connection.migration_context.needs_migration?
  rescue StandardError => e
    Rails.logger.error("Health check - Migrations check failed: #{e.message}")
    false
  end

  def check_audit_chain
    return true unless defined?(AuditLog)
    return true if AuditLog.count.zero?

    result = AuditLog.verify_chain(limit: 100)
    result[:valid]
  rescue StandardError => e
    Rails.logger.error("Health check - Audit chain failed: #{e.message}")
    false
  end
end
