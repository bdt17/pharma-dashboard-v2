module Api
  module V1
    class GeofenceEventsController < BaseController
      before_action :set_shipment, only: [:create]

      def controller_scope
        'geofence_events'
      end

      # GET /api/v1/geofence_events
      def index
        events = @tenant.geofence_events.includes(:shipment, :geofence)
        events = apply_filters(events)
        result = paginate(events.order(recorded_at: :desc))

        render json: {
          geofence_events: result[:data].map { |e| event_json(e) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/geofence_events/:id
      def show
        event = @tenant.geofence_events.find(params[:id])

        render json: { geofence_event: event_json(event, detailed: true) }
      end

      # POST /api/v1/geofence_events
      def create
        geofence = Geofence.find_by(id: params[:geofence_id])

        event = @shipment.geofence_events.create!(
          tenant: @tenant,
          geofence: geofence,
          geofence_name: geofence&.name || params[:geofence_name],
          event_type: params[:event_type],
          latitude: params[:latitude],
          longitude: params[:longitude],
          distance_from_boundary: params[:distance],
          dwell_time_seconds: params[:dwell_time_seconds],
          recorded_at: params[:recorded_at] || Time.current,
          metadata: params[:metadata] || {}
        )

        audit!(action: 'create', resource: event, changes: event.attributes)

        # Create alert for geofence events
        if params[:event_type].in?(%w[enter exit])
          Alert.create_geofence_alert(
            @shipment,
            event_type: params[:event_type],
            geofence_name: event.geofence_name,
            severity: :info
          )
        end

        render json: { geofence_event: event_json(event) }, status: :created
      end

      private

      def set_shipment
        @shipment = @tenant.shipments.find(params[:shipment_id])
      end

      def apply_filters(scope)
        scope = scope.where(shipment_id: params[:shipment_id]) if params[:shipment_id].present?
        scope = scope.where(event_type: params[:event_type]) if params[:event_type].present?
        scope = scope.where(geofence_id: params[:geofence_id]) if params[:geofence_id].present?
        scope = scope.where("recorded_at >= ?", params[:from]) if params[:from].present?
        scope = scope.where("recorded_at <= ?", params[:to]) if params[:to].present?
        scope
      end

      def event_json(event, detailed: false)
        json = {
          id: event.id,
          shipment_id: event.shipment_id,
          event_type: event.event_type,
          geofence_name: event.geofence_name,
          location: {
            lat: event.latitude,
            lng: event.longitude
          },
          recorded_at: event.recorded_at
        }

        if detailed
          json[:geofence_id] = event.geofence_id
          json[:distance_from_boundary] = event.distance_from_boundary
          json[:dwell_time_seconds] = event.dwell_time_seconds
          json[:metadata] = event.metadata
          json[:shipment_tracking] = event.shipment.tracking_number
          json[:created_at] = event.created_at
        end

        json
      end
    end
  end
end
