class Driver < ApplicationRecord
  # Devise already handles password (uses encrypted_password)
  validates :name, :phone_number, :email, presence: true
  validates :email, uniqueness: true
end
