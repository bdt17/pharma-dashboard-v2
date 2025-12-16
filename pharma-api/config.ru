#!/usr/bin/env ruby
require 'rack'
require 'json'

# INLINE 50x BATCHES (Render restart PROOF)
BATCHES = (1..50).map do |i|
  {
    id: i,
    lot_number: "LOT#{1000+i}",
    temperature: (1.0 + rand(7.0)).round(1),
    status: rand(2) == 0 ? "✅ ON TRACK" : "⚠️ TEMP ALERT",
    truck_id: "TRK#{100+rand(900)}",
    location: "Warehouse #{rand(1..3)} → DC #{rand(1..5)}",
    timestamp: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
  }
end

puts "🚀 FDA PHARMA API v2 - #{BATCHES.length}x Batches STARTING"

app = Rack::Builder.app do
  use Rack::ContentType, 'application/json'
  
  map "/" do
    run ->(env) { 
      [200, {'Content-Type' => 'application/json'}, 
       [JSON.generate({"status": "LIVE", "batches": BATCHES.length})]]
    }
  end
  
  map "/batches" do
    run ->(env) { [200, {'Content-Type' => 'application/json'}, [BATCHES.to_json]] }
  end
end

run app
