#!/usr/bin/env ruby
require 'rack'
require_relative './batches_50'
run ->(env) {
  case env['PATH_INFO']
  when '/' then [200, {'Content-Type' => 'application/json'}, ["FDA PHARMA API v2 - 50x Batches LIVE"]]
  when '/batches' then [200, {'Content-Type' => 'application/json'}, [BATCHES.to_json]]
  else [404, {'Content-Type' => 'text/plain'}, ["Not Found"]]
  end
}
map "/tickets" do
  run ->(env) { [200, {'Content-Type' => 'application/json'}, [BATCHES[0..10].map { |b| {id: b[:id], batch: b[:lot_number], status: "open"} }.to_json]] }
end
map "/pricing" do
  run ->(env) { [200, {'Content-Type' => 'application/json'}, [[{"plan": "Enterprise", "price": "$999/mo", "batches": "Unlimited"}].to_json]] }
end
