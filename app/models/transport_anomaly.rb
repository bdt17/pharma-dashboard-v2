class TransportAnomaly < ApplicationRecord
  validates :severity, presence: true
end
