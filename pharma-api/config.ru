#!/usr/bin/env ruby
require 'rack'

run Rack::Builder.new do
  map "/" do
    run ->(env) { [200, {'Content-Type' => 'text/plain'}, ["FDA PHARMA API v3 - 50 BATCHES LIVE"]] }
  end
  
  map "/batches" do
    run ->(env) { 
      [200, {'Content-Type' => 'application/json'}, ["[{\"id\":1,\"lot\":\"LOT1001\",\"temp\":2.3,\"status\":\"✅\"},{\"id\":2,\"lot\":\"LOT1002\",\"temp\":5.7,\"status\":\"⚠️\"}]"]]
    }
  end
end
