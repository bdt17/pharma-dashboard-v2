module Api
  module V1
    class TenantsController < BaseController
      def controller_scope
        'tenants'
      end

      # GET /api/v1/tenant
      def show
        render json: {
          tenant: tenant_json(@tenant, detailed: true)
        }
      end

      # PATCH /api/v1/tenant
      def update
        if @tenant.update(tenant_params)
          audit!(action: 'update', resource: @tenant, changes: @tenant.previous_changes)

          render json: { tenant: tenant_json(@tenant) }
        else
          render json: { errors: @tenant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/tenant/stats
      def stats
        render json: {
          stats: {
            shipments: {
              total: @tenant.shipments.count,
              active: @tenant.shipments.active.count,
              with_excursions: @tenant.shipments.with_excursions.count
            },
            alerts: {
              total: @tenant.alerts.count,
              open: @tenant.alerts.status_open.count,
              critical: @tenant.alerts.severity_critical.active.count
            },
            api_keys: {
              total: @tenant.api_keys.count,
              active: @tenant.api_keys.active.count
            },
            users: {
              total: @tenant.users.count,
              active: @tenant.users.active.count
            }
          }
        }
      end

      private

      def tenant_params
        params.require(:tenant).permit(:name, :contact_email, settings: {})
      end

      def tenant_json(tenant, detailed: false)
        json = {
          id: tenant.id,
          name: tenant.name,
          subdomain: tenant.subdomain,
          status: tenant.status,
          created_at: tenant.created_at
        }

        if detailed
          json[:contact_email] = tenant.contact_email
          json[:settings] = tenant.settings
          json[:updated_at] = tenant.updated_at
        end

        json
      end
    end
  end
end
