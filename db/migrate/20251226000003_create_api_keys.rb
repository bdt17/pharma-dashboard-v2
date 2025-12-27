class CreateApiKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name, null: false
      t.string :key_digest, null: false
      t.string :prefix, null: false  # First 8 chars for identification
      t.string :scopes, array: true, default: []
      t.datetime :last_used_at
      t.datetime :expires_at
      t.boolean :active, default: true
      t.integer :rate_limit, default: 1000  # requests per hour
      t.bigint :request_count, default: 0
      t.timestamps
    end

    add_index :api_keys, :key_digest, unique: true
    add_index :api_keys, :prefix
    add_index :api_keys, :active
    add_index :api_keys, :expires_at
  end
end
