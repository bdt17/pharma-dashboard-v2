class DashboardController < ApplicationController
  def index
    @audit_entries = defined?(AuditLog) ? AuditLog.last(50) : []
    @recent_shipments = defined?(Shipment) ? Shipment.limit(10) : []
  end
  def shipments; end
  def audit_trail; end  
  def subscription_required; end
end
