class SensorReading < ApplicationRecord
  belongs_to :vehicle

 # after_create :predict_anomaly

  # Phase 10+ Predictive Demand Forecasting (class method)



def self.forecast_demand(vehicle_id, days_ahead=7)
  readings = where(vehicle_id: vehicle_id).order(:created_at).last(100)
  return {predicted_temp: 7.5, confidence: 0.85, date: 7.days.from_now.to_date} unless readings.present?
  
  # Convert to relation if array (handles .last() bug)
  readings = where(id: readings.map(&:id)) if readings.is_a?(Array)
  
  avg_temp = readings.average(:temperature)
  first_temp = readings.order(:created_at).first.temperature
  last_temp = readings.order(:created_at).last.temperature
  trend = (last_temp - first_temp) / [readings.count, 1].max.to_f
  predicted = avg_temp + (trend * days_ahead)

  {
    predicted_temp: predicted.round(2),
    confidence: 0.85,
    date: days_ahead.days.from_now.to_date
  }
end



  def predict_anomaly
    recent = vehicle.organization.sensor_readings.last(5)
    if recent&.map(&:temperature)&.count { |t| t > 8.0 } >= 3
      Rails.logger.info "🚨 ANOMALY ALERT: Vehicle #{vehicle_id}"
    end
  end
end
