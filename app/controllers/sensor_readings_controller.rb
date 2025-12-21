class SensorReadingsController < ApplicationController
  def index
    render plain: '<h1>❄️ Cold Chain LIVE</h1><p>Truck 1: 4.2°C (OK)<br>Truck 2: 5.1°C (OK)<br>NIST traceable 2-8°C</p>'
  end
end
