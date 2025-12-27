# frozen_string_literal: true

# Phase 12: Performance Indexes for 2,500 Truck Scale
# Optimizes queries for high-throughput GPS streaming and FDA compliance reporting
class AddPhase12PerformanceIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    # GPS readings - high-throughput queries (10K events/sec target)
    add_index :gps_readings, [:vehicle_id, :created_at],
              algorithm: :concurrently,
              name: "idx_gps_vehicle_time",
              if_not_exists: true

    # Temperature events - compliance reports and excursion tracking
    add_index :temperature_events, [:shipment_id, :recorded_at],
              algorithm: :concurrently,
              name: "idx_temp_shipment_time",
              if_not_exists: true

    add_index :temperature_events, [:tenant_id, :excursion, :recorded_at],
              algorithm: :concurrently,
              name: "idx_temp_tenant_excursion",
              if_not_exists: true

    # Audit logs - FDA 21 CFR Part 11 chain verification
    add_index :audit_logs, [:tenant_id, :sequence_number],
              algorithm: :concurrently,
              name: "idx_audit_tenant_sequence",
              if_not_exists: true

    add_index :audit_logs, [:resource_type, :resource_id],
              algorithm: :concurrently,
              name: "idx_audit_resource",
              if_not_exists: true

    # Shipments - fleet tracking dashboard
    add_index :shipments, [:tenant_id, :status, :updated_at],
              algorithm: :concurrently,
              name: "idx_shipments_tenant_status",
              if_not_exists: true

    # Alerts - real-time monitoring
    add_index :alerts, [:tenant_id, :severity, :status],
              algorithm: :concurrently,
              name: "idx_alerts_tenant_severity",
              if_not_exists: true

    # Geofence events - location tracking
    add_index :geofence_events, [:shipment_id, :recorded_at],
              algorithm: :concurrently,
              name: "idx_geofence_shipment_time",
              if_not_exists: true

    # API keys - authentication lookups
    add_index :api_keys, [:prefix, :active],
              algorithm: :concurrently,
              name: "idx_api_keys_prefix_active",
              if_not_exists: true
  end
end
