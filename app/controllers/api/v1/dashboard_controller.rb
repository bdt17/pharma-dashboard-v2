class Api::V1::DashboardController < ApplicationController
  def index
    render json: {
      active_shipments: Shipment.where(status: "in_transit").count,
      exceptions_open: ExceptionEvent.where("occurred_at >= ?", 7.days.ago).count,
      otif_percent: 96.2,
      co2_month: 1250.5,
      vendors: [{name: "UPS", score: 98}, {name: "FedEx", score: 95}]
    }
  end
end
