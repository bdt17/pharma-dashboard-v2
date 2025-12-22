#!/bin/bash
endpoints=(
  "/" 
  "/dashboard" 
  "/vehicles" 
  "/map" 
  "/audit_events" 
  "/geofences" 
  "/sensor_readings" 
  "/electronic_signatures" 
  "/dea_shipments" 
  "/transport_anomalies" 
  "/reports"
  # 🔥 PHASE 8 GPS ADDED
  "/api/v1/realtime"
)

echo "🚚 PHARMA TRANSPORT v8.0 - $(date)"
for endpoint in "${endpoints[@]}"; do
  status=$(curl -s -o /dev/null -w "%{http_code}" "https://pharma-dashboard-s4g5.onrender.com$endpoint")
  if [ "$status" = "200" ]; then
    echo "✅ $endpoint [200]"
  else
    echo "❌ $endpoint [$status]"
  fi
done
echo "🌐 $(curl -s https://pharma-dashboard-s4g5.onrender.com/health | head -1)"
