require 'rack'
run Rack::Builder.new do
  use Rack::Static, 
    urls: ['/'], 
    root: 'public',
    index: 'index.html'
  run ->(env) { 
    [200, {'Content-Type' => 'text/html'}, [File.read('public/index.html', nil) || 'Pharma LIVE!']]
  }
end
