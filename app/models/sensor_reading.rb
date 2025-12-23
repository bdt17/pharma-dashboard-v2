class SensorReading < ApplicationRecord
  belongs_to :vehicle

  after_create :predict_anomaly

  # Phase 10+ Predictive Demand Forecasting (class method)
  def self.forecast_demand(vehicle_id, days_ahead=7)
    readings = where(vehicle_id: vehicle_id).order(:timestamp).last(100)
    return unless readings.size >= 3
    
    avg_temp = readings.average(:temperature)
    trend = (readings.last.temperature - readings.first.temperature) / readings.size.to_f
    predicted = avg_temp + (trend * days_ahead)
    
    # Create forecast record (assumes DemandForecast model exists)
    DemandForecast.create!(
      organization: Organization.first,  # Multi-tenant: use current org in production
      vehicle_id: vehicle_id, 
      predicted_temp: predicted.round(2),
      confidence: 0.85,
      forecast_date: days_ahead.days.from_now
    )
    
    "Forecast created: #{predicted.round(2)}°C on #{days_ahead.days.from_now.to_date}"
  end

  private

  def predict_anomaly
    recent = vehicle.organization.sensor_readings.last(5)
    if recent&.map(&:temperature)&.count { |t| t > 8.0 } >= 3
      Rails.logger.info "🚨 ANOMALY ALERT: Vehicle #{vehicle_id}"
    end
  end
end
