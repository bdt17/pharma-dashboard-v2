class CreateTamperEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :tamper_events do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.float :vibration
      t.float :light_exposure
      t.float :anomaly_score
      t.string :status

      t.timestamps
    end
  end
end
