class AuditLog < ApplicationRecord
  scope :recent, -> { order(created_at: :desc).limit(5) }
end
