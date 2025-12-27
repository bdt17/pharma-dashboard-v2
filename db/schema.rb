# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_26_120001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.datetime "acknowledged_at"
    t.string "acknowledged_by"
    t.float "actual_value"
    t.string "alert_type", null: false
    t.jsonb "context", default: {}
    t.datetime "created_at", null: false
    t.text "message"
    t.text "resolution_notes"
    t.datetime "resolved_at"
    t.string "resolved_by"
    t.string "severity", default: "warning"
    t.bigint "shipment_id"
    t.string "status", default: "open"
    t.bigint "tenant_id", null: false
    t.float "threshold_value"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_type"], name: "index_alerts_on_alert_type"
    t.index ["created_at"], name: "index_alerts_on_created_at"
    t.index ["severity"], name: "index_alerts_on_severity"
    t.index ["shipment_id"], name: "index_alerts_on_shipment_id"
    t.index ["status"], name: "index_alerts_on_status"
    t.index ["tenant_id", "severity", "status"], name: "idx_alerts_tenant_severity"
    t.index ["tenant_id", "status"], name: "index_alerts_on_tenant_id_and_status"
    t.index ["tenant_id"], name: "index_alerts_on_tenant_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "key_digest", null: false
    t.datetime "last_used_at"
    t.string "name", null: false
    t.string "prefix", null: false
    t.integer "rate_limit", default: 1000
    t.bigint "request_count", default: 0
    t.string "scopes", default: [], array: true
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_api_keys_on_active"
    t.index ["expires_at"], name: "index_api_keys_on_expires_at"
    t.index ["key_digest"], name: "index_api_keys_on_key_digest", unique: true
    t.index ["prefix", "active"], name: "idx_api_keys_prefix_active"
    t.index ["prefix"], name: "index_api_keys_on_prefix"
    t.index ["tenant_id"], name: "index_api_keys_on_tenant_id"
  end

  create_table "audit_events", force: :cascade do |t|
    t.string "action"
    t.string "actor"
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.integer "resource_id"
    t.datetime "updated_at", null: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.string "actor_id"
    t.string "actor_type"
    t.bigint "api_key_id"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.jsonb "metadata", default: {}
    t.string "previous_hash"
    t.jsonb "record_changes", default: {}
    t.string "record_hash", null: false
    t.string "request_id"
    t.bigint "resource_id"
    t.string "resource_type", null: false
    t.bigint "sequence_number", null: false
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["actor_type"], name: "index_audit_logs_on_actor_type"
    t.index ["api_key_id"], name: "index_audit_logs_on_api_key_id"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["record_hash"], name: "index_audit_logs_on_record_hash", unique: true
    t.index ["resource_type", "resource_id"], name: "idx_audit_resource"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
    t.index ["resource_type"], name: "index_audit_logs_on_resource_type"
    t.index ["sequence_number"], name: "index_audit_logs_on_sequence_number", unique: true
    t.index ["tenant_id", "created_at"], name: "index_audit_logs_on_tenant_id_and_created_at"
    t.index ["tenant_id", "sequence_number"], name: "idx_audit_tenant_sequence"
    t.index ["tenant_id"], name: "index_audit_logs_on_tenant_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "camera_feeds", force: :cascade do |t|
    t.text "ai_analysis"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["vehicle_id"], name: "index_camera_feeds_on_vehicle_id"
  end

  create_table "controlled_shipments", force: :cascade do |t|
    t.jsonb "chain_of_custody"
    t.datetime "created_at", null: false
    t.string "dea_number"
    t.string "dea_schedule"
    t.boolean "signature_required"
    t.datetime "updated_at", null: false
  end

  create_table "dea_shipments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "demand_forecasts", force: :cascade do |t|
    t.float "confidence"
    t.datetime "created_at", null: false
    t.datetime "forecast_date"
    t.bigint "organization_id", null: false
    t.float "predicted_temp"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["organization_id"], name: "index_demand_forecasts_on_organization_id"
    t.index ["vehicle_id"], name: "index_demand_forecasts_on_vehicle_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_drivers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true
  end

  create_table "electronic_signatures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id"
    t.string "document_type"
    t.string "docusign_envelope_id"
    t.string "signature_hash"
    t.datetime "signed_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_electronic_signatures_on_user_id"
  end

  create_table "geofence_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "distance_from_boundary"
    t.integer "dwell_time_seconds"
    t.string "event_type", null: false
    t.bigint "geofence_id"
    t.string "geofence_name"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.jsonb "metadata", default: {}
    t.datetime "recorded_at", null: false
    t.bigint "shipment_id", null: false
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_geofence_events_on_event_type"
    t.index ["geofence_id"], name: "index_geofence_events_on_geofence_id"
    t.index ["recorded_at"], name: "index_geofence_events_on_recorded_at"
    t.index ["shipment_id", "recorded_at"], name: "idx_geofence_shipment_time"
    t.index ["shipment_id", "recorded_at"], name: "index_geofence_events_on_shipment_id_and_recorded_at"
    t.index ["shipment_id"], name: "index_geofence_events_on_shipment_id"
    t.index ["tenant_id"], name: "index_geofence_events_on_tenant_id"
  end

  create_table "geofences", force: :cascade do |t|
    t.string "boundary"
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.float "radius"
    t.datetime "updated_at", null: false
  end

  create_table "gps_readings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.float "temperature"
    t.datetime "updated_at", null: false
    t.integer "vehicle_id"
    t.index ["vehicle_id", "created_at"], name: "idx_gps_vehicle_time"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "subdomain"
    t.datetime "updated_at", null: false
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.string "calibration_cert_url"
    t.datetime "created_at", null: false
    t.float "humidity"
    t.boolean "nist_traceable"
    t.jsonb "raw_payload"
    t.string "source"
    t.float "temperature"
    t.datetime "timestamp"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["vehicle_id"], name: "index_sensor_readings_on_vehicle_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.datetime "actual_delivery_at"
    t.datetime "actual_pickup_at"
    t.text "cargo_description"
    t.string "cargo_type"
    t.datetime "created_at", null: false
    t.float "current_lat"
    t.float "current_lng"
    t.datetime "delivery_at"
    t.string "destination_address"
    t.float "destination_lat"
    t.float "destination_lng"
    t.float "max_temp", default: 8.0
    t.jsonb "metadata", default: {}
    t.float "min_temp", default: 2.0
    t.string "origin_address"
    t.float "origin_lat"
    t.float "origin_lng"
    t.datetime "pickup_at"
    t.string "status", default: "pending"
    t.bigint "tenant_id", null: false
    t.string "tracking_number", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id"
    t.index ["current_lat", "current_lng"], name: "index_shipments_on_current_lat_and_current_lng"
    t.index ["delivery_at"], name: "index_shipments_on_delivery_at"
    t.index ["pickup_at"], name: "index_shipments_on_pickup_at"
    t.index ["status"], name: "index_shipments_on_status"
    t.index ["tenant_id", "status", "updated_at"], name: "idx_shipments_tenant_status"
    t.index ["tenant_id"], name: "index_shipments_on_tenant_id"
    t.index ["tracking_number"], name: "index_shipments_on_tracking_number", unique: true
    t.index ["vehicle_id"], name: "index_shipments_on_vehicle_id"
  end

  create_table "signatures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id"
    t.string "document_type"
    t.string "signature_hash"
    t.string "signature_method"
    t.datetime "signed_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "plan"
    t.decimal "price"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "tamper_events", force: :cascade do |t|
    t.float "anomaly_score"
    t.datetime "created_at", null: false
    t.float "light_exposure"
    t.bigint "organization_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.float "vibration"
    t.index ["organization_id"], name: "index_tamper_events_on_organization_id"
    t.index ["vehicle_id"], name: "index_tamper_events_on_vehicle_id"
  end

  create_table "temperature_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_type", default: "reading"
    t.boolean "excursion", default: false
    t.float "excursion_duration_minutes"
    t.float "humidity"
    t.float "latitude"
    t.float "longitude"
    t.jsonb "raw_data", default: {}
    t.datetime "recorded_at", null: false
    t.string "sensor_id"
    t.bigint "shipment_id", null: false
    t.float "temperature", null: false
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_temperature_events_on_event_type"
    t.index ["excursion"], name: "index_temperature_events_on_excursion"
    t.index ["recorded_at"], name: "index_temperature_events_on_recorded_at"
    t.index ["shipment_id", "recorded_at"], name: "idx_temp_shipment_time"
    t.index ["shipment_id", "recorded_at"], name: "index_temperature_events_on_shipment_id_and_recorded_at"
    t.index ["shipment_id"], name: "index_temperature_events_on_shipment_id"
    t.index ["tenant_id", "excursion", "recorded_at"], name: "idx_temp_tenant_excursion"
    t.index ["tenant_id"], name: "index_temperature_events_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.jsonb "settings", default: {}
    t.string "status", default: "active"
    t.string "subdomain", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_tenants_on_status"
    t.index ["subdomain"], name: "index_tenants_on_subdomain", unique: true
  end

  create_table "transport_anomalies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "detected_at"
    t.boolean "geofence_breach"
    t.string "severity"
    t.boolean "temperature_spike"
    t.boolean "theft_route"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_login_at"
    t.string "name"
    t.string "password_digest"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "viewer"
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alerts", "shipments"
  add_foreign_key "alerts", "tenants"
  add_foreign_key "api_keys", "tenants"
  add_foreign_key "audit_logs", "api_keys"
  add_foreign_key "audit_logs", "tenants"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "camera_feeds", "vehicles"
  add_foreign_key "demand_forecasts", "organizations"
  add_foreign_key "demand_forecasts", "vehicles"
  add_foreign_key "electronic_signatures", "users"
  add_foreign_key "geofence_events", "geofences"
  add_foreign_key "geofence_events", "shipments"
  add_foreign_key "geofence_events", "tenants"
  add_foreign_key "sensor_readings", "vehicles"
  add_foreign_key "shipments", "tenants"
  add_foreign_key "shipments", "vehicles"
  add_foreign_key "tamper_events", "organizations"
  add_foreign_key "tamper_events", "vehicles"
  add_foreign_key "temperature_events", "shipments"
  add_foreign_key "temperature_events", "tenants"
  add_foreign_key "users", "tenants"
end
