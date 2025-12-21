class AddSourceToSensorReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :sensor_readings, :source, :string
  end
end
