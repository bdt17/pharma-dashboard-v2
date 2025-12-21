class CreateSignatures < ActiveRecord::Migration[8.1]
  def change
    create_table :signatures do |t|
      t.integer :user_id
      t.string :document_type
      t.integer :document_id
      t.datetime :signed_at
      t.string :signature_method
      t.string :signature_hash

      t.timestamps
    end
  end
end
