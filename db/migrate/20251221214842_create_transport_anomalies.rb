class CreateTransportAnomalies < ActiveRecord::Migration[8.1]
  def change
    create_table :transport_anomalies do |t|
      t.boolean :temperature_spike
      t.boolean :geofence_breach
      t.boolean :theft_route
      t.datetime :detected_at
      t.string :severity

      t.timestamps
    end
  end
end
