class AddGeofenceLocationColumns < ActiveRecord::Migration[8.1]
  def up
    add_column :geofences, :latitude, :float unless column_exists?(:geofences, :latitude)
    add_column :geofences, :longitude, :float unless column_exists?(:geofences, :longitude)
    add_column :geofences, :radius, :float unless column_exists?(:geofences, :radius)
  end

  def down
    remove_column :geofences, :latitude if column_exists?(:geofences, :latitude)
    remove_column :geofences, :longitude if column_exists?(:geofences, :longitude)
    remove_column :geofences, :radius if column_exists?(:geofences, :radius)
  end
end
