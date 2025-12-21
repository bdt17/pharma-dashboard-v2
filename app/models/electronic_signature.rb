class ElectronicSignature < ApplicationRecord
  validates :document_type, presence: true
end
