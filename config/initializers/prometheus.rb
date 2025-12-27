# frozen_string_literal: true

# Prometheus Metrics for Pharma Transport
# Phase 12: Enterprise Kubernetes Monitoring
#
# Metrics exposed at /metrics for Prometheus scraping

require "prometheus/client"

# Only initialize in production or when explicitly enabled
if Rails.env.production? || ENV["ENABLE_PROMETHEUS"] == "true"

  # Initialize Prometheus registry
  prometheus = Prometheus::Client.registry

  # ═══════════════════════════════════════════════════════════════════════════
  # HTTP METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  HTTP_REQUESTS_TOTAL = prometheus.counter(
    :http_requests_total,
    docstring: "Total HTTP requests processed",
    labels: [:method, :path, :status]
  )

  HTTP_REQUEST_DURATION_SECONDS = prometheus.histogram(
    :http_request_duration_seconds,
    docstring: "HTTP request duration in seconds",
    labels: [:method, :path],
    buckets: [0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # BUSINESS METRICS - FDA 21 CFR Part 11 Compliance
  # ═══════════════════════════════════════════════════════════════════════════

  GPS_EVENTS_TOTAL = prometheus.counter(
    :gps_events_total,
    docstring: "Total GPS events processed",
    labels: [:tenant_id]
  )

  TEMPERATURE_READINGS_TOTAL = prometheus.counter(
    :temperature_readings_total,
    docstring: "Total temperature readings recorded",
    labels: [:tenant_id]
  )

  TEMPERATURE_EXCURSIONS_TOTAL = prometheus.counter(
    :temperature_excursions_total,
    docstring: "Total temperature excursions detected",
    labels: [:tenant_id, :severity]
  )

  AUDIT_LOG_ENTRIES_TOTAL = prometheus.counter(
    :audit_log_entries_total,
    docstring: "Total audit log entries created",
    labels: [:action, :resource_type]
  )

  AUDIT_CHAIN_VALID = prometheus.gauge(
    :audit_chain_valid,
    docstring: "Audit chain integrity status (1=valid, 0=invalid)",
    labels: [:tenant_id]
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # SHIPMENT METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  ACTIVE_SHIPMENTS = prometheus.gauge(
    :active_shipments,
    docstring: "Number of active shipments",
    labels: [:tenant_id, :status]
  )

  SHIPMENT_DURATION_HOURS = prometheus.histogram(
    :shipment_duration_hours,
    docstring: "Shipment duration in hours",
    labels: [:tenant_id],
    buckets: [1, 2, 4, 8, 12, 24, 48, 72, 168]
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # ALERT METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  OPEN_ALERTS = prometheus.gauge(
    :open_alerts,
    docstring: "Number of open alerts",
    labels: [:tenant_id, :severity, :alert_type]
  )

  ALERT_ACKNOWLEDGEMENT_TIME_SECONDS = prometheus.histogram(
    :alert_acknowledgement_time_seconds,
    docstring: "Time to acknowledge alerts in seconds",
    labels: [:tenant_id, :severity],
    buckets: [60, 300, 600, 1800, 3600, 7200]
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # WEBSOCKET METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  ACTIVE_WEBSOCKET_CONNECTIONS = prometheus.gauge(
    :active_websocket_connections,
    docstring: "Number of active WebSocket connections",
    labels: [:channel]
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # DATABASE METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  DB_POOL_SIZE = prometheus.gauge(
    :db_pool_size,
    docstring: "Database connection pool size"
  )

  DB_POOL_CONNECTIONS = prometheus.gauge(
    :db_pool_connections,
    docstring: "Database connections in use"
  )

  # ═══════════════════════════════════════════════════════════════════════════
  # SIDEKIQ METRICS
  # ═══════════════════════════════════════════════════════════════════════════

  SIDEKIQ_JOBS_TOTAL = prometheus.counter(
    :sidekiq_jobs_total,
    docstring: "Total Sidekiq jobs processed",
    labels: [:queue, :status]
  )

  SIDEKIQ_JOB_DURATION_SECONDS = prometheus.histogram(
    :sidekiq_job_duration_seconds,
    docstring: "Sidekiq job duration in seconds",
    labels: [:queue, :job_class],
    buckets: [0.1, 0.5, 1, 2.5, 5, 10, 30, 60]
  )

  # Make metrics available globally
  Rails.application.config.prometheus = {
    registry: prometheus,
    http_requests_total: HTTP_REQUESTS_TOTAL,
    http_request_duration: HTTP_REQUEST_DURATION_SECONDS,
    gps_events: GPS_EVENTS_TOTAL,
    temperature_readings: TEMPERATURE_READINGS_TOTAL,
    temperature_excursions: TEMPERATURE_EXCURSIONS_TOTAL,
    audit_entries: AUDIT_LOG_ENTRIES_TOTAL,
    audit_chain_valid: AUDIT_CHAIN_VALID,
    active_shipments: ACTIVE_SHIPMENTS,
    open_alerts: OPEN_ALERTS,
    websocket_connections: ACTIVE_WEBSOCKET_CONNECTIONS
  }

  Rails.logger.info "[Prometheus] Metrics initialized for Pharma Transport"

end
