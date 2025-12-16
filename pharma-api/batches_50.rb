BATCHES = (1..50).map do |i|
  {
    id: i,
    lot_number: "LOT#{1000+i}",
    temperature: (1.0 + rand(7.0)).round(1),
    status: rand(2) == 0 ? "✅ ON TRACK" : "⚠️ TEMP ALERT",
    truck_id: "TRK#{100+rand(900)}",
    location: "Warehouse #{rand(1..3)} → DC",
    timestamp: Time.now.utc.iso8601
  }
end
