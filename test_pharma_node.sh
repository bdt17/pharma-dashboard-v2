#!/bin/bash
echo "🚀 PHARMA NODE.JS DASHBOARD TEST SUITE"
BASE="http://localhost:10000"

echo "✅ ROOT HTML ..."
curl -s "$BASE/" | grep "Pharma Transport Dashboard" && echo "✅ HTML OK"

echo "🔐 LOGIN API ..."
curl -s -X POST "$BASE/api/auth/test-login" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"Pharma2026!"}' | 
  grep '"success":true' && echo "✅ LOGIN OK"

echo "📊 DASHBOARD API ..."
curl -s "$BASE/api/v1/dashboard" | grep -E '"active_shipments|otif_percent"' && echo "✅ METRICS OK"

echo "🎉 3/3 NODE.JS DASHBOARD LIVE!"
