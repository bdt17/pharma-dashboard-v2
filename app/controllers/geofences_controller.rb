class GeofencesController < ApplicationController
  def index
    @geofences = [
      {name: "Phoenix Hospital", lat: 33.4484, lng: -112.0740},
      {name: "Phoenix Warehouse", lat: 33.4500, lng: -112.0700}
    ]
    render layout: 'application'
  end
end
