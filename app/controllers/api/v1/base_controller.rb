module Api
  module V1
    class BaseController < ApplicationController
      include ApiAuthentication

      skip_before_action :verify_authenticity_token

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :bad_request

      protected

      # Alias for cleaner controller code
      def audit!(action:, resource:, changes: {}, metadata: {})
        audit_action(action: action, resource: resource, changes: changes, metadata: metadata)
      end

      def paginate(scope)
        page = (params[:page] || 1).to_i
        per_page = [(params[:per_page] || 25).to_i, 100].min

        total = scope.count
        records = scope.offset((page - 1) * per_page).limit(per_page)

        {
          data: records,
          meta: {
            page: page,
            per_page: per_page,
            total: total,
            total_pages: (total.to_f / per_page).ceil
          }
        }
      end

      # Tenant-scoped helper
      def tenant_scope(model)
        model.where(tenant: current_tenant)
      end

      private

      def not_found(exception)
        render json: {
          error: "Record not found",
          details: exception.message,
          resource: exception.model
        }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: {
          error: "Validation failed",
          details: exception.record.errors.full_messages,
          fields: exception.record.errors.to_hash
        }, status: :unprocessable_entity
      end

      def bad_request(exception)
        render json: {
          error: "Bad request",
          details: exception.message
        }, status: :bad_request
      end
    end
  end
end
