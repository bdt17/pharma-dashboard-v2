class EnhanceUsersForApi < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :tenant, foreign_key: true
    add_column :users, :password_digest, :string
    add_column :users, :role, :string, default: 'viewer'
    add_column :users, :name, :string
    add_column :users, :last_login_at, :datetime
    add_column :users, :active, :boolean, default: true

    add_index :users, :role
    add_index :users, :active
  end
end
