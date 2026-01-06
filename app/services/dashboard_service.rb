class DashboardService
  def initialize(user = nil)
    @user = user
  end

  def summary
    {
      active_shipments: Shipment.where(status: "in_transit").count,
      exceptions_open: ExceptionEvent.where("occurred_at >= ?", 7.days.ago).count,
      otif_percent: calculate_otif.round(2),
      co2_this_month: ShipmentKpi.where("created_at >= ?", Time.current.beginning_of_month).sum(:co2_kg),
      vendors_top5: VendorPerformanceSnapshot.order(period_start: :desc).limit(5).pluck(:vendor_id, :on_time_percent)
    }
  end

  private

  def calculate_otif
    delivered = Shipment.where(status: "delivered")
    total = delivered.count
    return 0 if total.zero?
    on_time = delivered.where("actual_delivery_at <= planned_delivery_at").count
    (on_time.to_f / total * 100)
  end
end
