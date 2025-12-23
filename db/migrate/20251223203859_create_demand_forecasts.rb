class CreateDemandForecasts < ActiveRecord::Migration[8.1]
  def change
    create_table :demand_forecasts do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.float :predicted_temp
      t.float :confidence
      t.datetime :forecast_date

      t.timestamps
    end
  end
end
