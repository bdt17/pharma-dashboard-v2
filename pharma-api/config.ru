#!/usr/bin/env ruby
require 'rack'

app = proc do |env|
  case env['PATH_INFO']
  when '/' 
    [200, {'Content-Type' => 'text/plain'}, ['FDA PHARMA API v6 LIVE']]
  when '/batches'
    [200, {'Content-Type' => 'application/json'}, ['[{"id":1,"lot":"LOT1001","temp":2.3,"status":"OK","truck":"TRK456"},{"id":2,"lot":"LOT1002","temp":5.7,"status":"ALERT","truck":"TRK789"},{"id":3,"lot":"LOT1003","temp":3.1,"status":"OK","truck":"TRK123"},{"id":4,"lot":"LOT1004","temp":6.8,"status":"ALERT","truck":"TRK234"},{"id":5,"lot":"LOT1005","temp":4.2,"status":"OK","truck":"TRK567"}]']]
  else
    [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
  end
end

run app
