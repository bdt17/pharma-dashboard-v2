# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def self.up
    change_table :users do |t|
      # SKIPPED: All Devise columns already exist in users table
    end

    # SKIPPED: All indexes already exist
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
