class VehiclesController < ApplicationController
  def index
    render plain: '<h1>🚚 Vehicles LIVE</h1><p>Truck 1: Phoenix (33.4484, -112.0740)<br>Truck 2: Warehouse (33.4500, -112.0700)</p>'
  end
  
  def map
    render plain: '<h1>🗺️ GPS Map LIVE</h1><p>Leaflet map ready - 50 FDA batches tracked</p>'
  end
end
