class ApiKeyAuthenticator
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    # Only apply to /api/v1 routes
    if request.path.start_with?('/api/v1')
      api_key = extract_api_key(request)

      if api_key.nil?
        return unauthorized_response("Missing API key")
      end

      authenticated_key = ApiKey.authenticate(api_key)

      if authenticated_key.nil?
        return unauthorized_response("Invalid API key")
      end

      if authenticated_key.rate_limited?
        return rate_limited_response
      end

      # Store authenticated key and tenant in request env
      env['pharma.api_key'] = authenticated_key
      env['pharma.tenant'] = authenticated_key.tenant
      env['pharma.tenant_id'] = authenticated_key.tenant_id
    end

    @app.call(env)
  end

  private

  def extract_api_key(request)
    # Check Authorization header first (Bearer token)
    auth_header = request.headers['Authorization']
    if auth_header&.start_with?('Bearer ')
      return auth_header.sub('Bearer ', '')
    end

    # Check X-API-Key header
    api_key_header = request.headers['X-API-Key']
    return api_key_header if api_key_header.present?

    # Check query param (not recommended for production)
    request.params['api_key']
  end

  def unauthorized_response(message)
    [
      401,
      { 'Content-Type' => 'application/json' },
      [{ error: message, status: 401 }.to_json]
    ]
  end

  def rate_limited_response
    [
      429,
      {
        'Content-Type' => 'application/json',
        'Retry-After' => '3600'
      },
      [{ error: "Rate limit exceeded", status: 429 }.to_json]
    ]
  end
end
