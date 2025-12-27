class CreateGeofenceEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :geofence_events do |t|
      t.references :shipment, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.references :geofence, foreign_key: true
      t.string :event_type, null: false  # enter, exit, dwell
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :geofence_name
      t.float :distance_from_boundary
      t.integer :dwell_time_seconds
      t.datetime :recorded_at, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :geofence_events, :event_type
    add_index :geofence_events, :recorded_at
    add_index :geofence_events, [:shipment_id, :recorded_at]
  end
end
