class Drivers::DashboardController < ApplicationController
  before_action :authenticate_driver!
  
  def index
    @current_driver = current_driver
  end
  
  def checkin
    truck = Vehicle.find_by(name: "Truck 001")
    if truck && params[:latitude] && params[:longitude]
      truck.update!(
        latitude: params[:latitude].to_f, 
        longitude: params[:longitude].to_f, 
        updated_at: Time.current
      )
      render json: { status: 'success' }
    else
      render json: { status: 'error' }, status: 400
    end
  end
end
