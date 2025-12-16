#!/usr/bin/env ruby
require 'rack'
require 'json'
require_relative './batches_50'

use Rack::ContentType, 'application/json'

map "/" do
  run ->(env) { 
    [200, {}, [JSON.generate({"status": "LIVE", "batches": BATCHES.length})]]
  }
end

map "/batches" do
  run ->(env) { [200, {}, [BATCHES.to_json]] }
end
