module Api
  module V1
    class TemperatureEventsController < BaseController
      before_action :set_shipment, only: [:create]

      def controller_scope
        'temperature_events'
      end

      # GET /api/v1/temperature_events
      def index
        events = @tenant.temperature_events.includes(:shipment)
        events = apply_filters(events)
        result = paginate(events.order(recorded_at: :desc))

        render json: {
          temperature_events: result[:data].map { |e| event_json(e) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/temperature_events/:id
      def show
        event = @tenant.temperature_events.find(params[:id])

        render json: { temperature_event: event_json(event, detailed: true) }
      end

      # POST /api/v1/temperature_events
      def create
        event = TemperatureEvent.record(
          @shipment,
          temperature: params[:temperature],
          humidity: params[:humidity],
          lat: params[:latitude],
          lng: params[:longitude],
          sensor_id: params[:sensor_id],
          raw_data: params[:raw_data] || {}
        )

        audit!(action: 'create', resource: event, changes: event.attributes)

        # Create alert if excursion detected
        if event.excursion?
          threshold = event.temperature > @shipment.max_temp ? @shipment.max_temp : @shipment.min_temp
          Alert.create_temperature_alert(@shipment, temperature: event.temperature, threshold: threshold, severity: :critical)
        end

        render json: { temperature_event: event_json(event) }, status: :created
      end

      # POST /api/v1/temperature_events/bulk
      def bulk_create
        events = []
        errors = []

        params[:events].each_with_index do |event_params, index|
          shipment = @tenant.shipments.find_by(id: event_params[:shipment_id])
          unless shipment
            errors << { index: index, error: "Shipment not found" }
            next
          end

          begin
            event = TemperatureEvent.record(
              shipment,
              temperature: event_params[:temperature],
              humidity: event_params[:humidity],
              lat: event_params[:latitude],
              lng: event_params[:longitude],
              sensor_id: event_params[:sensor_id],
              raw_data: event_params[:raw_data] || {}
            )
            events << event
          rescue => e
            errors << { index: index, error: e.message }
          end
        end

        audit!(action: 'bulk_create', resource: @tenant, metadata: { count: events.size, errors: errors.size })

        render json: {
          created: events.size,
          errors: errors,
          temperature_events: events.map { |e| event_json(e) }
        }, status: errors.any? ? :multi_status : :created
      end

      private

      def set_shipment
        @shipment = @tenant.shipments.find(params[:shipment_id])
      end

      def apply_filters(scope)
        scope = scope.where(shipment_id: params[:shipment_id]) if params[:shipment_id].present?
        scope = scope.where(excursion: true) if params[:excursions_only] == 'true'
        scope = scope.where("recorded_at >= ?", params[:from]) if params[:from].present?
        scope = scope.where("recorded_at <= ?", params[:to]) if params[:to].present?
        scope
      end

      def event_json(event, detailed: false)
        json = {
          id: event.id,
          shipment_id: event.shipment_id,
          temperature: event.temperature,
          humidity: event.humidity,
          excursion: event.excursion,
          event_type: event.event_type,
          recorded_at: event.recorded_at,
          location: {
            lat: event.latitude,
            lng: event.longitude
          }
        }

        if detailed
          json[:sensor_id] = event.sensor_id
          json[:raw_data] = event.raw_data
          json[:shipment_tracking] = event.shipment.tracking_number
          json[:created_at] = event.created_at
        end

        json
      end
    end
  end
end
