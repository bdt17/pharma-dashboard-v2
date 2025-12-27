class DashboardController < ApplicationController
  def index
    render plain: 'Dashboard LIVE - Phase 6+7+8+11.5'
  end

  def shipments
    @shipments = Shipment.includes(:tenant, :alerts, :temperature_events)
                         .order(created_at: :desc)
                         .limit(100)
  end

  def audit_trail
    @audit_logs = AuditLog.includes(:tenant, :api_key)
                          .order(created_at: :desc)
                          .limit(500)
    @chain_valid = AuditLog.verify_chain[:valid]
  end
end
