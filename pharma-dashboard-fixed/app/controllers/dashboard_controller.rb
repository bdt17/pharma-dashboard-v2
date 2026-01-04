# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def index
    @vehicles = Vehicle.all.includes(:location_points)
  end

  def vehicles_json
    render json: Vehicle.all.as_json(only: [:id, :identifier, :current_latitude, :current_longitude, :active])
  end
end
