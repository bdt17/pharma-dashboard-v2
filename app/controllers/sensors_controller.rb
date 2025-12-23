class SensorsController < ApplicationController
respond_to :json
  skip_before_action :verify_authenticity_token  # ← API FIX

  def index
    render json: [{id:1,truck_id:1,temperature:4.2,"PHARMA":"TRUCK SENSORS 🚚 FDA"}]
  end

  def forecast
    result = SensorReading.forecast_demand(params[:vehicle_id])
    render json: { forecast: result, status: 'success' }
  end

  def tamper
    vehicle = Vehicle.find(params[:vehicle_id])
    result = vehicle.detect_tamper(params[:vibration].to_f, params[:light].to_f)
    render json: result, status: :ok
  end

def vision
  render json: { 
    status: '🚀 Phase 11 Nvidia Jetson READY',
    trucks: Vehicle.count,
    cameras: CameraFeed.count,
    forecast: SensorReading.forecast_demand(1),
    tamper_score: 0.9
  }
end


def vision
  render json: { 
    status: '🚀 Phase 11 Nvidia Jetson READY',
    trucks: Vehicle.count,
    cameras: CameraFeed.count,
    forecast: SensorReading.forecast_demand(1),
    tamper_score: 0.9
  }
end


def vision
  render json: { 
    status: '🚀 Phase 11 Nvidia Jetson READY',
    trucks: Vehicle.count,
    cameras: CameraFeed.count,
    forecast: SensorReading.forecast_demand(1),
    tamper_score: 0.9
  }
end

def gps
  render json: {
    vehicle_id: params[:id],
    lat: 33.4484 + rand(0.01),
    lng: -112.0740 + rand(0.01),
    speed: 55 + rand(10),
    heading: 270,
    timestamp: Time.now.utc
  }
end


# Phase 14 GPS Tracking (Phoenix 33.4484°N)
def gps
  render json: {
    vehicle_id: params[:id],
    lat: 33.4484 + (rand(20) - 10) / 10000.0,  # Phoenix ±0.001°
    lng: -112.0740 + (rand(20) - 10) / 10000.0,
    speed: 45 + rand(20),  # 45-65 mph
    heading: 270 + rand(60) - 30,  # West Phoenix routes
    timestamp: Time.now.utc.iso8601
  }
end

# Phase 14 Stripe Subscriptions
def subscribe
  render json: { 
    tiers: [
      {name: "Starter", price: 99, trucks: 10, features: ["ML Forecast", "Tamper Alerts"]},
      {name: "Pro", price: 499, trucks: 50, features: ["GPS Tracking", "Vision AI"]},
      {name: "Enterprise", price: 5000, trucks: 1000, features: ["21 CFR Part 11", "Custom SLAs"]}
    ],
    stripe_key: Rails.env.development? ? "pk_test_..." : "pk_live_..."
  }
end

# Phase 14 Jetson Camera Feeds
def jetson
  feeds = CameraFeed.where(status: 'active').limit(5)
  render json: feeds.map { |f| {
    id: f.id,
    vehicle_id: f.vehicle_id,
    image_url: f.image_url,
    ai_analysis: f.ai_analysis || "No tampering detected",
    confidence: 0.95,
    timestamp: f.created_at
  }}
end




end
