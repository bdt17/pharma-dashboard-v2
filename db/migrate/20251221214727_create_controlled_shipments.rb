class CreateControlledShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :controlled_shipments do |t|
      t.string :dea_schedule
      t.string :dea_number
      t.jsonb :chain_of_custody
      t.boolean :signature_required

      t.timestamps
    end
  end
end
