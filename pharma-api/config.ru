#!/usr/bin/env ruby
require 'rack'
require_relative './batches_50'

run Rack::Builder.new do
  use Rack::ContentType, 'application/json'
  
  map "/" do
    run ->(env) { [200, {}, ["FDA PHARMA API v2 - 50x Batches LIVE"]] }
  end
  
  map "/batches" do
    run ->(env) { [200, {}, [BATCHES.to_json]] }
  end
end
