class DashboardService
  def self.summary
    {
      active_shipments: Shipment.where(status: "in_transit").count,
      exceptions_open: ExceptionEvent.recent.count
    }
  end
end
