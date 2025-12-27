module Api
  module V1
    class ApiKeysController < BaseController
      before_action :set_api_key, only: [:show, :update, :destroy, :rotate]

      def controller_scope
        'api_keys'
      end

      # GET /api/v1/api_keys
      def index
        keys = @tenant.api_keys
        keys = keys.active if params[:active_only] == 'true'
        result = paginate(keys.order(created_at: :desc))

        render json: {
          api_keys: result[:data].map { |k| key_json(k) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/api_keys/:id
      def show
        render json: { api_key: key_json(@api_key, detailed: true) }
      end

      # POST /api/v1/api_keys
      def create
        @api_key = @tenant.api_keys.build(api_key_params)

        if @api_key.save
          audit!(action: 'create', resource: @api_key, metadata: { name: @api_key.name })

          # Return the raw key only on creation
          render json: {
            api_key: key_json(@api_key).merge(key: @api_key.raw_key),
            warning: "Store this key securely. It will not be shown again."
          }, status: :created
        else
          render json: { errors: @api_key.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/api_keys/:id
      def update
        if @api_key.update(api_key_update_params)
          audit!(action: 'update', resource: @api_key, changes: @api_key.previous_changes)

          render json: { api_key: key_json(@api_key) }
        else
          render json: { errors: @api_key.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/api_keys/:id
      def destroy
        audit!(action: 'delete', resource: @api_key, metadata: { name: @api_key.name })
        @api_key.destroy

        render json: { message: "API key deleted" }
      end

      # POST /api/v1/api_keys/:id/rotate
      def rotate
        old_prefix = @api_key.prefix

        @api_key.send(:generate_key)
        @api_key.save!

        audit!(action: 'rotate', resource: @api_key, changes: { old_prefix: old_prefix, new_prefix: @api_key.prefix })

        render json: {
          api_key: key_json(@api_key).merge(key: @api_key.raw_key),
          warning: "Store this new key securely. The old key is now invalid."
        }
      end

      private

      def set_api_key
        @api_key = @tenant.api_keys.find(params[:id])
      end

      def api_key_params
        params.require(:api_key).permit(:name, :expires_at, :rate_limit, scopes: [])
      end

      def api_key_update_params
        params.require(:api_key).permit(:name, :active, :expires_at, :rate_limit, scopes: [])
      end

      def key_json(key, detailed: false)
        json = {
          id: key.id,
          name: key.name,
          prefix: key.prefix,
          active: key.active,
          scopes: key.scopes,
          last_used_at: key.last_used_at,
          expires_at: key.expires_at,
          created_at: key.created_at
        }

        if detailed
          json[:rate_limit] = key.rate_limit
          json[:request_count] = key.request_count
          json[:expired] = key.expired?
          json[:rate_limited] = key.rate_limited?
        end

        json
      end
    end
  end
end
