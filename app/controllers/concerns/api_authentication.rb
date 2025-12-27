module ApiAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_key!
    before_action :set_current_tenant
  end

  class_methods do
    def skip_api_authentication(**options)
      skip_before_action :authenticate_api_key!, **options
      skip_before_action :set_current_tenant, **options
    end

    def require_scopes(*scopes, **options)
      before_action(**options) do
        validate_scopes!(scopes)
      end
    end
  end

  protected

  def current_api_key
    @current_api_key ||= request.env['pharma.api_key']
  end

  def current_tenant
    @current_tenant ||= request.env['pharma.tenant']
  end

  def api_authenticated?
    current_api_key.present? && current_tenant.present?
  end

  private

  def authenticate_api_key!
    return if current_api_key.present?

    # Try to authenticate from headers if middleware didn't catch it
    raw_key = extract_api_key_from_request
    if raw_key.present?
      api_key = ApiKey.authenticate(raw_key)
      if api_key
        @current_api_key = api_key
        @current_tenant = api_key.tenant
        return
      end
    end

    render_unauthorized("Invalid or missing API key")
  end

  def set_current_tenant
    @tenant = current_tenant  # Set @tenant for controller access
    unless current_tenant&.active?
      render_unauthorized("Tenant is inactive or not found")
    end
  end

  def validate_scopes!(required_scopes)
    return if required_scopes.empty?

    missing = required_scopes.reject { |scope| current_api_key&.has_scope?(scope) }
    if missing.any?
      render json: {
        error: "Insufficient permissions",
        required_scopes: missing,
        message: "API key missing required scopes: #{missing.join(', ')}"
      }, status: :forbidden
    end
  end

  def extract_api_key_from_request
    # Bearer token
    auth_header = request.headers['Authorization']
    return auth_header.sub('Bearer ', '') if auth_header&.start_with?('Bearer ')

    # X-API-Key header
    request.headers['X-API-Key'].presence || params[:api_key]
  end

  def render_unauthorized(message)
    render json: {
      error: "Unauthorized",
      message: message,
      hint: "Include API key via 'Authorization: Bearer <key>' or 'X-API-Key: <key>' header"
    }, status: :unauthorized
  end

  # Audit helper
  def audit_action(action:, resource:, changes: {}, metadata: {})
    return unless current_tenant

    AuditLog.log(
      tenant: current_tenant,
      action: action,
      resource: resource,
      api_key: current_api_key,
      changes: changes,
      metadata: metadata.merge(
        endpoint: "#{request.method} #{request.path}",
        params: request.params.except(:controller, :action, :api_key).to_h
      ),
      request: request
    )
  end

  # Rate limiting check
  def check_rate_limit!
    if current_api_key&.rate_limited?
      render json: {
        error: "Rate limit exceeded",
        limit: current_api_key.rate_limit,
        reset_at: 1.hour.from_now.iso8601
      }, status: :too_many_requests
    end
  end
end
