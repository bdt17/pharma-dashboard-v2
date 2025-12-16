#!/usr/bin/env ruby
require 'rack'
require_relative './batches_50'

run ->(env) {
  case env['PATH_INFO']
  when '/' then [200, {'Content-Type' => 'application/json'}, ["API LIVE"]]
  when '/batches' then [200, {'Content-Type' => 'application/json'}, [BATCHES.to_json]]
  else [404, {'Content-Type' => 'text/plain'}, ["Not Found"]]
  end
}
