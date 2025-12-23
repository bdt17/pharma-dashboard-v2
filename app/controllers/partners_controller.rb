class PartnersController < ApplicationController
  def pfizer
    @shipment = Shipment.last || Shipment.create(
      truck_id: 1, 
      destination: 'Pfizer DC Phoenix', 
      status: 'en_route',
      temperature_range: '2-8°C'
    )
  end
end
