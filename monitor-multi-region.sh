#!/bin/bash
while true; do
  ts=$(date '+%H:%M')
  us_ping=$(curl -s --max-time 5 https://pharma-dashboard-s4g5.onrender.com/api/v1/dashboard | jq -r '.active_shipments')
  eu_ping=$(curl -s --max-time 5 https://pharma-dashboard-eu.onrender.com/api/v1/dashboard | jq -r '.active_shipments // "DOWN"')
  gps=$(curl -s -X POST https://pharma-dashboard-s4g5.onrender.com/api/gps -H "Content-Type: application/json" -d '{"shipment_id":999,"lat":33.4484,"lng":-112.074,"temp_c":4.2}' | jq -r '.active_trackers')
  echo "[$ts] US:$us_ping | EU:$eu_ping | GPS:$gps"
  sleep 60
done
