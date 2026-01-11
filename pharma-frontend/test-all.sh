#!/bin/bash
echo "🚀 Testing Pharma Transport Dashboard - Phases 13-14"
echo "=================================================="

# Fix port conflicts first
echo "🔧 Clearing port 3000..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true

# Start backend in background
cd ~/Pharma_Transport_all
echo "⚙️  Starting backend APIs..."
npm install express pg dotenv >/dev/null 2>&1
node app.js >/dev/null 2>&1 &
BACKEND_PID=$!
sleep 3

# Test ALL endpoints
echo ""
echo "📊 PHASE 13 TESTS:"
echo "-----------------"

# Tesla FSD
curl -s http://localhost:3000/api/tesla/VIN123 | jq '.fsd_version' | head -1

# Waymo Phoenix  
curl -s http://localhost:3000/api/waymo/ride456 | jq '.status' | head -1

# AI Excursion (CRITICAL test)
curl -s "http://localhost:3000/api/ai/predict-excursion?temp=50&duration_hours=4" | \
  jq '{risk_score: .risk_score, level: .risk_level, mitigation: .mitigation}' | jq -r .

echo ""
echo "📈 PHASE 14 TESTS:"
echo "-----------------"

# Marketplace bids
curl -s http://localhost:3000/api/marketplace/bids/PHX-TEST-001 | \
  jq '.lowest_bid, .market_rate'

# Digital Twin
curl -s http://localhost:3000/api/digital-twin/TRUCK001 | \
  jq '.physics.reefer_temp, .position.heading'

# Marketplace bid submission
echo '{"load_id":"PHX-TEST-001","carrier_id":"CAR999","bid_amount":2250,"eta_hours":5.5}' | \
  curl -s -X POST http://localhost:3000/api/marketplace/bid \
  -H "Content-Type: application/json" -d @- | jq '.bid.accepted'

echo ""
echo "🌐 PRODUCTION RENDER TESTS:"
curl -s "https://pharma-dashboard-s4g5.onrender.com/api/ai/predict-excursion?temp=50&duration_hours=4" | \
  jq '{risk_score: .risk_score, level: .risk_level}'

echo ""
echo "✅ ALL TESTS COMPLETE"
echo "Backend PID: $BACKEND_PID"
echo "Frontend: cd pharma-frontend && npm run dev"
echo "Dashboard: http://localhost:5173"

# Cleanup on exit
trap "kill $BACKEND_PID 2>/dev/null" EXIT
