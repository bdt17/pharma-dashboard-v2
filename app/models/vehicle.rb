class Vehicle < ApplicationRecord
  belongs_to :organization
  has_many :sensor_readings, dependent: :destroy
  has_many :locations, -> { order(created_at: :desc) }

  # Phase 10+ Tamper Detection
  def detect_tamper(vibration, light)
    score = (vibration > 2.0 || light > 50) ? 0.9 : 0.1
    Rails.logger.info "🚨 TAMPER SCORE: #{score} (vib:#{vibration}, light:#{light})"
    { 
      score: score, 
      status: score > 0.5 ? '🚨 ALERT' : '✅ OK',
      vehicle: name
    }
  end
end
