class SecurityMiddleware
  def initialize(app)
    @app = app
  end
  
  def call(env)
    path = env['PATH_INFO']
    if path.match?(/\.env|master\.key|database\.yml|credentials/i)
      return [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end
    @app.call(env)
  end
end
