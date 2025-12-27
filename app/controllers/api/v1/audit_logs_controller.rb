module Api
  module V1
    class AuditLogsController < BaseController
      def controller_scope
        'audit_logs'
      end

      # GET /api/v1/audit_logs
      def index
        logs = @tenant.audit_logs
        logs = apply_filters(logs)
        result = paginate(logs.order(created_at: :desc))

        render json: {
          audit_logs: result[:data].map { |l| log_json(l) },
          meta: result[:meta]
        }
      end

      # GET /api/v1/audit_logs/:id
      def show
        log = @tenant.audit_logs.find(params[:id])

        render json: { audit_log: log_json(log, detailed: true) }
      end

      # GET /api/v1/audit_logs/verify
      def verify
        result = AuditLog.verify_chain(
          tenant_id: @tenant.id,
          start_seq: params[:start_sequence]&.to_i,
          end_seq: params[:end_sequence]&.to_i
        )

        render json: {
          verification: result,
          verified_at: Time.current
        }
      end

      # GET /api/v1/audit_logs/for_resource
      def for_resource
        logs = @tenant.audit_logs
          .for_resource(params[:resource_type], params[:resource_id])
          .order(created_at: :desc)

        result = paginate(logs)

        render json: {
          audit_logs: result[:data].map { |l| log_json(l) },
          meta: result[:meta]
        }
      end

      private

      def apply_filters(scope)
        scope = scope.where(action: params[:audit_action]) if params[:audit_action].present?
        scope = scope.where(resource_type: params[:resource_type]) if params[:resource_type].present?
        scope = scope.where(actor_type: params[:actor_type]) if params[:actor_type].present?
        scope = scope.where("created_at >= ?", params[:from]) if params[:from].present?
        scope = scope.where("created_at <= ?", params[:to]) if params[:to].present?
        scope
      end

      def log_json(log, detailed: false)
        json = {
          id: log.id,
          action: log.action,
          resource_type: log.resource_type,
          resource_id: log.resource_id,
          actor_type: log.actor_type,
          actor_id: log.actor_id,
          sequence_number: log.sequence_number,
          created_at: log.created_at
        }

        if detailed
          json[:changes] = log.record_changes
          json[:metadata] = log.metadata
          json[:ip_address] = log.ip_address
          json[:user_agent] = log.user_agent
          json[:request_id] = log.request_id
          json[:record_hash] = log.record_hash
          json[:previous_hash] = log.previous_hash
        end

        json
      end
    end
  end
end
