class AddStatusToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :status, :string
  end
end
