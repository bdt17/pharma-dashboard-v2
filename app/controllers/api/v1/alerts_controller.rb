module Api
  module V1
    class AlertsController < BaseController
      before_action :set_alert, only: [:show, :acknowledge, :resolve]

      def controller_scope
        'alerts'
      end

      # GET /api/v1/alerts
      def index
        alerts = @tenant.alerts.includes(:shipment)
        alerts = apply_filters(alerts)
        result = paginate(alerts.order(created_at: :desc))

        render json: {
          alerts: result[:data].map { |a| alert_json(a) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/alerts/:id
      def show
        render json: { alert: alert_json(@alert, detailed: true) }
      end

      # POST /api/v1/alerts
      def create
        shipment = params[:shipment_id] ? @tenant.shipments.find(params[:shipment_id]) : nil

        @alert = @tenant.alerts.create!(
          shipment: shipment,
          alert_type: params[:alert_type],
          severity: params[:severity] || 'warning',
          title: params[:title],
          message: params[:message],
          threshold_value: params[:threshold_value],
          actual_value: params[:actual_value],
          context: params[:context] || {}
        )

        audit!(action: 'create', resource: @alert, changes: @alert.attributes)

        render json: { alert: alert_json(@alert) }, status: :created
      end

      # POST /api/v1/alerts/:id/acknowledge
      def acknowledge
        @alert.acknowledge!(by: params[:acknowledged_by] || "api_key:#{current_api_key.id}")

        audit!(action: 'acknowledge', resource: @alert)

        render json: { alert: alert_json(@alert) }
      end

      # POST /api/v1/alerts/:id/resolve
      def resolve
        @alert.resolve!(
          by: params[:resolved_by] || "api_key:#{current_api_key.id}",
          notes: params[:resolution_notes]
        )

        audit!(action: 'resolve', resource: @alert, changes: { resolution_notes: params[:resolution_notes] })

        render json: { alert: alert_json(@alert) }
      end

      # GET /api/v1/alerts/summary
      def summary
        alerts = @tenant.alerts

        render json: {
          summary: {
            total: alerts.count,
            open: alerts.status_open.count,
            acknowledged: alerts.status_acknowledged.count,
            resolved: alerts.status_resolved.count,
            by_severity: {
              critical: alerts.severity_critical.active.count,
              warning: alerts.severity_warning.active.count,
              info: alerts.severity_info.active.count
            },
            by_type: {
              temperature: alerts.alert_type_temperature.active.count,
              geofence: alerts.alert_type_geofence.active.count,
              tamper: alerts.alert_type_tamper.active.count,
              delay: alerts.alert_type_delay.active.count
            }
          }
        }
      end

      private

      def set_alert
        @alert = @tenant.alerts.find(params[:id])
      end

      def apply_filters(scope)
        scope = scope.where(status: params[:status]) if params[:status].present?
        scope = scope.where(severity: params[:severity]) if params[:severity].present?
        scope = scope.where(alert_type: params[:alert_type]) if params[:alert_type].present?
        scope = scope.where(shipment_id: params[:shipment_id]) if params[:shipment_id].present?
        scope = scope.active if params[:active_only] == 'true'
        scope = scope.where("created_at >= ?", params[:from]) if params[:from].present?
        scope = scope.where("created_at <= ?", params[:to]) if params[:to].present?
        scope
      end

      def alert_json(alert, detailed: false)
        json = {
          id: alert.id,
          alert_type: alert.alert_type,
          severity: alert.severity,
          status: alert.status,
          title: alert.title,
          message: alert.message,
          shipment_id: alert.shipment_id,
          created_at: alert.created_at
        }

        if detailed
          json[:threshold_value] = alert.threshold_value
          json[:actual_value] = alert.actual_value
          json[:acknowledged_by] = alert.acknowledged_by
          json[:acknowledged_at] = alert.acknowledged_at
          json[:resolved_by] = alert.resolved_by
          json[:resolved_at] = alert.resolved_at
          json[:resolution_notes] = alert.resolution_notes
          json[:context] = alert.context
          json[:shipment_tracking] = alert.shipment&.tracking_number
        end

        json
      end
    end
  end
end
