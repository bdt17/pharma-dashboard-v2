class GeofencesController < ApplicationController
  def index
    render plain: "📍 Geofences LIVE - Phoenix zones", status: 200
  end
end
