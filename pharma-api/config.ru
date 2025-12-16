#!/usr/bin/env ruby
require 'rack'

# STATIC 50x BATCHES JSON (Render PROOF)
BATCHES_JSON = '[{"id":1,"lot_number":"LOT1001","temperature":2.3,"status":"✅ ON TRACK","truck_id":"TRK456","location":"Warehouse 1 → DC 2","timestamp":"2025-12-15T18:00:00Z"},{"id":2,"lot_number":"LOT1002","temperature":5.7,"status":"⚠️ TEMP ALERT","truck_id":"TRK789","location":"Warehouse 2 → DC 1","timestamp":"2025-12-15T18:01:00Z"},{"id":3,"lot_number":"LOT1003","temperature":3.1,"status":"✅ ON TRACK","truck_id":"TRK123","location":"Warehouse 3 → DC 3","timestamp":"2025-12-15T18:02:00Z"},{"id":4,"lot_number":"LOT1004","temperature":6.8,"status":"⚠️ TEMP ALERT","truck_id":"TRK234","location":"Warehouse 1 → DC 4","timestamp":"2025-12-15T18:03:00Z"},{"id":5,"lot_number":"LOT1005","temperature":4.2,"status":"✅ ON TRACK","truck_id":"TRK567","location":"Warehouse 2 → DC 5","timestamp":"2025-12-15T18:04:00Z"}]' * 10

app = Rack::Builder.app do
  map "/" do
    run ->(env) { [200, {'Content-Type' => 'application/json'}, [BATCHES_JSON]] }
  end
  
  map "/batches" do
    run ->(env) { [200, {'Content-Type' => 'application/json'}, [BATCHES_JSON]] }
  end
end

run app
