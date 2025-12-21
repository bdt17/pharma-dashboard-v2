class AddPhase7FieldsToWhatever < ActiveRecord::Migration[8.1]
  def change
    # Skip if tables exist
    unless table_exists?(:electronic_signatures)
      create_table :electronic_signatures do |t|
        t.integer :user_id
        t.string :document_type
        t.integer :document_id
        t.datetime :signed_at
        t.string :signature_hash
        t.string :docusign_id
        t.timestamps
      end
    end
  end
end
