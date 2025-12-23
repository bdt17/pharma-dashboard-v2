class TamperEvent < ApplicationRecord
  belongs_to :organization
  belongs_to :vehicle
end
