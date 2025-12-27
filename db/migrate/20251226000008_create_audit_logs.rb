class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :api_key, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action, null: false
      t.string :resource_type, null: false
      t.bigint :resource_id
      t.string :actor_type  # user, api_key, system
      t.string :actor_id
      t.string :ip_address
      t.string :user_agent
      t.string :request_id
      t.jsonb :changes, default: {}
      t.jsonb :metadata, default: {}
      t.string :previous_hash  # Hash chain for immutability
      t.string :record_hash, null: false  # SHA256 of this record
      t.bigint :sequence_number, null: false
      t.timestamps
    end

    add_index :audit_logs, :action
    add_index :audit_logs, :resource_type
    add_index :audit_logs, [:resource_type, :resource_id]
    add_index :audit_logs, :actor_type
    add_index :audit_logs, :created_at
    add_index :audit_logs, :sequence_number, unique: true
    add_index :audit_logs, :record_hash, unique: true
    add_index :audit_logs, [:tenant_id, :created_at]
  end
end
