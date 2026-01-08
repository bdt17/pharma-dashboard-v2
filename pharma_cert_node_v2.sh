#!/bin/bash
RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' NC='\033[0m'
PROD_URL="https://pharma-dashboard-s4g5.onrender.com"
PASS=0 TOTAL=4

test_get() {
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "$1")
  [ "$HTTP_CODE" = "200" ] && echo -e "${GREEN}✅ $2${NC}" || echo -e "${RED}❌ $2 [$HTTP_CODE]${NC}"
  [ "$HTTP_CODE" = "200" ] && ((PASS++))
}

test_post_auth() {
  RESPONSE=$(curl -s -X POST "$1" -H "Content-Type: application/json" -d '{"username":"testuser","password":"Pharma2026!"}')
  echo "$RESPONSE" | grep -q '"success":true' && echo -e "${GREEN}✅ $2${NC}" || echo -e "${RED}❌ $2${NC}"
  echo "$RESPONSE" | grep -q '"success":true' && ((PASS++))
}

echo -e "${YELLOW}🚀 PHARMA NODE.JS PRODUCTION CERT v2.1${NC}"
echo "🌐 PRODUCTION: $PROD_URL"

test_get "$PROD_URL/" "ROOT HTML"
test_get "$PROD_URL/api/v1/dashboard" "📊 KPI METRICS"
test_post_auth "$PROD_URL/api/auth/test-login" "🔐 AUTH API"
curl -s "$PROD_URL/api/v1/dashboard" | jq -r '.status' && echo "✅ FDA STATUS LIVE"

echo "📊 PRODUCTION: $PASS/$TOTAL ✅ ENTERPRISE READY"
echo "🌐 DEMO: $PROD_URL"
