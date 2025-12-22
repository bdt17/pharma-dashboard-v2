class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.string :plan
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
