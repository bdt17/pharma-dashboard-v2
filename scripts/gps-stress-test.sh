#!/bin/bash
URL="https://pharma-dashboard-s4g5.onrender.com/api/gps"
for i in {1..1000}; do
  curl -s -X POST $URL \
    -H "Content-Type: application/json" \
    -d "{\"shipment_id\":$i,\"lat\":33.4484,\"lng\":-112.074,\"temp_c\":4.2}" > /dev/null &
done
echo "🚀 1000 GPS trackers deployed - Phase 12 scale test"
