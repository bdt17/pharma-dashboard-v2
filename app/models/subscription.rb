class Subscription < ApplicationRecord
  # Line 3 likely: enum status: { trial: 0, active: 1, canceled: 2 }  # WRONG
  enum status: [:trial, :active, :canceled]  # CORRECT - no args
  belongs_to :organization
end


belongs_to :organization
enum status: { trial: 0, active: 1, canceled: 2 }
