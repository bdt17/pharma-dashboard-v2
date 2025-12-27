class CreateAlerts < ActiveRecord::Migration[8.1]
  def change
    create_table :alerts do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :shipment, foreign_key: true
      t.string :alert_type, null: false  # temperature, geofence, tamper, delay
      t.string :severity, default: 'warning'  # info, warning, critical
      t.string :status, default: 'open'  # open, acknowledged, resolved
      t.string :title, null: false
      t.text :message
      t.float :threshold_value
      t.float :actual_value
      t.string :acknowledged_by
      t.datetime :acknowledged_at
      t.string :resolved_by
      t.datetime :resolved_at
      t.text :resolution_notes
      t.jsonb :context, default: {}
      t.timestamps
    end

    add_index :alerts, :alert_type
    add_index :alerts, :severity
    add_index :alerts, :status
    add_index :alerts, [:tenant_id, :status]
    add_index :alerts, :created_at
  end
end
