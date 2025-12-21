class AddNistFieldsToSensorReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :sensor_readings, :nist_traceable, :boolean
    add_column :sensor_readings, :calibration_cert_url, :string
    add_column :sensor_readings, :raw_payload, :jsonb
  end
end
