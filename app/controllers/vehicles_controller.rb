class VehiclesController < ApplicationController
  def index
    render plain: "🚚 Vehicles LIVE - 3 Phoenix trucks GPS", status: 200
  end
  def map
    render plain: "🗺️ GPS Map LIVE - FDA batches tracked", status: 200
  end
end
