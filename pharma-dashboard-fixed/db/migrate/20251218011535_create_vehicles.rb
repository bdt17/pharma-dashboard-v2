class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :identifier
      t.float :current_latitude
      t.float :current_longitude
      t.boolean :active

      t.timestamps
    end
  end
end
