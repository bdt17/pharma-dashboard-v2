class Tenant < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :temperature_events, dependent: :destroy
  has_many :geofence_events, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :audit_logs, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: "only lowercase letters, numbers, and hyphens" }

  scope :active, -> { where(status: 'active') }

  def active?
    status == 'active'
  end
end
