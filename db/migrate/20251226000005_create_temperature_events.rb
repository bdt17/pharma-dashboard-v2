class CreateTemperatureEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :temperature_events do |t|
      t.references :shipment, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.float :temperature, null: false
      t.float :humidity
      t.string :sensor_id
      t.string :event_type, default: 'reading'  # reading, excursion, alert
      t.boolean :excursion, default: false
      t.float :excursion_duration_minutes
      t.float :latitude
      t.float :longitude
      t.datetime :recorded_at, null: false
      t.jsonb :raw_data, default: {}
      t.timestamps
    end

    add_index :temperature_events, :recorded_at
    add_index :temperature_events, :excursion
    add_index :temperature_events, :event_type
    add_index :temperature_events, [:shipment_id, :recorded_at]
  end
end
