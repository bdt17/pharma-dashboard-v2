class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :vehicle, foreign_key: true
      t.string :tracking_number, null: false
      t.string :status, default: 'pending'
      t.string :origin_address
      t.string :destination_address
      t.float :origin_lat
      t.float :origin_lng
      t.float :destination_lat
      t.float :destination_lng
      t.float :current_lat
      t.float :current_lng
      t.float :min_temp, default: 2.0
      t.float :max_temp, default: 8.0
      t.string :cargo_type
      t.text :cargo_description
      t.datetime :pickup_at
      t.datetime :delivery_at
      t.datetime :actual_pickup_at
      t.datetime :actual_delivery_at
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :shipments, :tracking_number, unique: true
    add_index :shipments, :status
    add_index :shipments, [:current_lat, :current_lng]
    add_index :shipments, :pickup_at
    add_index :shipments, :delivery_at
  end
end
