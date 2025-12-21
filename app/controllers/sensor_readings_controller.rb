class SensorReadingsController < ApplicationController
  def index
    render plain: "❄️ Cold Chain LIVE - 2-8°C NIST", status: 200
  end
end
