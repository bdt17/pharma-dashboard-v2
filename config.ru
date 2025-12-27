require 'rack'

use Rack::Static, 
  urls: ['/'], 
  index: 'index.html', 
  root: 'public'

run lambda { |env|
  [200, {'Content-Type' => 'text/html'}, ['Pharma Transport LIVE!']]
}
