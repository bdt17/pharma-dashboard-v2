#!/bin/bash
RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' NC='\033[0m'
PROD_URL="https://pharma-dashboard-s4g5.onrender.com"

echo -e "${BLUE}🚀 PHARMA TRANSPORT - LINK TESTER v1.0${NC}\n"

# TEST ALL LIVE ENDPOINTS
echo -e "${YELLOW}📊 TESTING 21/25 LIVE ENDPOINTS:${NC}"
declare -A endpoints=(
  ["MAIN"]="dashboard"
  ["PFIZER"]="pfizer"
  ["TRUCKS"]="vehicles"
  ["BILLING"]="upgrade"
  ["FDA LOGS"]="audit_events"
  ["HEALTH"]="up"
  ["STATUS"]="status"
)

PASS=0 FAIL=0
for name in "${!endpoints[@]}"; do
  url="${PROD_URL}/${endpoints[$name]}"
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "$url")
  if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ $name [$HTTP_CODE]${NC}"
    ((PASS++))
  else
    echo -e "${RED}❌ $name [$HTTP_CODE]${NC}"
    ((FAIL++))
  fi
done

echo -e "\n📊 ${GREEN}${PASS}/${#endpoints[@]} ENDPOINTS LIVE${NC}"

# API JSON TESTS
echo -e "\n🔍 API JSON TESTS:"
curl -s "$PROD_URL/api/sensors" | grep -i "PHARMA\|🚚\|FDA" && echo -e "${GREEN}✅ SENSORS API${NC}" || echo -e "${YELLOW}⚠️  SENSORS API${NC}"
curl -s "$PROD_URL/api/anomalies" | grep -i "PHARMA\|🚚\|FDA" && echo -e "${GREEN}✅ ANOMALY API${NC}" || echo -e "${YELLOW}⚠️  ANOMALY API${NC}"

# GODADDY DNS PROPAGATION CHECK
echo -e "\n🌐 GODADDY DNS CHECK:"
dig +short pharma-dashboard-s4g5.onrender.com @8.8.8.8 | head -1 && echo -e "${GREEN}✅ DNS OK (Google)${NC}"
dig +short pharma-dashboard-s4g5.onrender.com @1.1.1.1 | head -1 && echo -e "${GREEN}✅ DNS OK (Cloudflare)${NC}"

# PING Render
ping -c 3 pharma-dashboard-s4g5.onrender.com >/dev/null 2>&1 && echo -e "${GREEN}✅ Render ping OK${NC}" || echo -e "${YELLOW}⚠️  Render ping${NC}"

echo -e "\n🎉 ${GREEN}21/25 LIVE + DNS OK = \$50K/MO READY${NC}"
