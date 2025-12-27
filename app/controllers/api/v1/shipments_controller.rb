module Api
  module V1
    class ShipmentsController < BaseController
      before_action :set_shipment, only: [:show, :update, :destroy, :temperature_events, :geofence_events, :alerts]

      def controller_scope
        'shipments'
      end

      # GET /api/v1/shipments
      def index
        shipments = @tenant.shipments.includes(:vehicle)
        shipments = apply_filters(shipments)
        result = paginate(shipments.order(created_at: :desc))

        audit!(action: 'list', resource: @tenant, metadata: { count: result[:meta][:total] })

        render json: {
          shipments: result[:data].map { |s| shipment_json(s) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/shipments/:id
      def show
        audit!(action: 'read', resource: @shipment)

        render json: {
          shipment: shipment_json(@shipment, detailed: true)
        }
      end

      # POST /api/v1/shipments
      def create
        @shipment = @tenant.shipments.build(shipment_params)

        if @shipment.save
          audit!(action: 'create', resource: @shipment, changes: @shipment.attributes)

          render json: { shipment: shipment_json(@shipment) }, status: :created
        else
          render json: { errors: @shipment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/shipments/:id
      def update
        changes = @shipment.attributes.dup

        if @shipment.update(shipment_params)
          changes = @shipment.previous_changes
          audit!(action: 'update', resource: @shipment, changes: changes)

          render json: { shipment: shipment_json(@shipment) }
        else
          render json: { errors: @shipment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/shipments/:id
      def destroy
        audit!(action: 'delete', resource: @shipment, changes: @shipment.attributes)
        @shipment.destroy

        render json: { message: "Shipment deleted" }
      end

      # GET /api/v1/shipments/:id/temperature_events
      def temperature_events
        events = @shipment.temperature_events.order(recorded_at: :desc)
        result = paginate(events)

        render json: {
          temperature_events: result[:data],
          meta: result[:meta]
        }
      end

      # GET /api/v1/shipments/:id/geofence_events
      def geofence_events
        events = @shipment.geofence_events.order(recorded_at: :desc)
        result = paginate(events)

        render json: {
          geofence_events: result[:data],
          meta: result[:meta]
        }
      end

      # GET /api/v1/shipments/:id/alerts
      def alerts
        alerts = @shipment.alerts.order(created_at: :desc)
        result = paginate(alerts)

        render json: {
          alerts: result[:data],
          meta: result[:meta]
        }
      end

      private

      def set_shipment
        @shipment = @tenant.shipments.find(params[:id])
      end

      def shipment_params
        params.require(:shipment).permit(
          :tracking_number, :status, :vehicle_id,
          :origin_address, :destination_address,
          :origin_lat, :origin_lng, :destination_lat, :destination_lng,
          :min_temp, :max_temp, :cargo_type, :cargo_description,
          :pickup_at, :delivery_at, :actual_pickup_at, :actual_delivery_at,
          metadata: {}
        )
      end

      def apply_filters(scope)
        scope = scope.where(status: params[:status]) if params[:status].present?
        scope = scope.where(vehicle_id: params[:vehicle_id]) if params[:vehicle_id].present?
        scope = scope.where("pickup_at >= ?", params[:from]) if params[:from].present?
        scope = scope.where("pickup_at <= ?", params[:to]) if params[:to].present?
        scope
      end

      def shipment_json(shipment, detailed: false)
        json = {
          id: shipment.id,
          tracking_number: shipment.tracking_number,
          status: shipment.status,
          origin_address: shipment.origin_address,
          destination_address: shipment.destination_address,
          current_location: {
            lat: shipment.current_lat,
            lng: shipment.current_lng
          },
          temperature_range: {
            min: shipment.min_temp,
            max: shipment.max_temp
          },
          cargo_type: shipment.cargo_type,
          pickup_at: shipment.pickup_at,
          delivery_at: shipment.delivery_at,
          temperature_compliant: shipment.temperature_compliant?,
          created_at: shipment.created_at,
          updated_at: shipment.updated_at
        }

        if detailed
          json[:cargo_description] = shipment.cargo_description
          json[:vehicle_id] = shipment.vehicle_id
          json[:actual_pickup_at] = shipment.actual_pickup_at
          json[:actual_delivery_at] = shipment.actual_delivery_at
          json[:duration_hours] = shipment.duration_hours
          json[:metadata] = shipment.metadata
          json[:current_temperature] = shipment.current_temperature
          json[:alerts_count] = shipment.alerts.active.count
          json[:excursions_count] = shipment.temperature_events.excursions.count
        end

        json
      end
    end
  end
end
