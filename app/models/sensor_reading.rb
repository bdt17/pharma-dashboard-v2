class SensorReading < ApplicationRecord
  belongs_to :vehicle
  
  after_create :predict_anomaly

  private

  def predict_anomaly
    recent = vehicle.organization.sensor_readings.last(5)
    if recent&.map(&:temperature)&.count { |t| t > 8.0 } >= 3
      Rails.logger.info "🚨 ANOMALY ALERT: Vehicle #{vehicle_id}"
    end
  end
end
