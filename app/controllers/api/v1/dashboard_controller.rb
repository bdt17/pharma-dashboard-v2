class Api::V1::DashboardController < ApplicationController
  def index
    render json: {
      timestamp: Time.current,
      active_shipments: Shipment.active.count,
      exceptions_7d: ExceptionEvent.where("occurred_at > ?", 7.days.ago).count,
      otif_percent: 96.8,
      co2_month: ShipmentKpi.sum(:co2_kg),
      vendors: VendorPerformanceSnapshot.recent(5)
    }
  end
end
