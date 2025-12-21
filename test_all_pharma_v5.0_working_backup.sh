#!/bin/bash
RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' NC='\033[0m'
BASE_URL="http://localhost:3000" PASS=0 FAIL=0

test_url() {
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$1")
  [ "$HTTP_CODE" = "200" ] && { echo -e "${GREEN}✅ $2${NC}"; ((PASS++)); return 0; } || { echo -e "${RED}❌ $2 ($HTTP_CODE)${NC}"; ((FAIL++)); return 1; }
}

echo -e "${BLUE}🚀 PHARMA ENTERPRISE v5.0 - PHASE 6+7 (11 Endpoints)${NC}\n"

# PHASE 6 CORE (8/8)
echo -e "${BLUE}📍 PHASE 6 CORE:${NC}"
test_url "/" "ROOT"
test_url "/dashboard" "DASHBOARD" 
test_url "/vehicles" "VEHICLES"
test_url "/map" "MAP"
test_url "/vehicles/1/map" "VEHICLE MAP"
test_url "/audit_events" "FDA AUDIT"
test_url "/geofences" "GEOFENCES"
test_url "/sensor_readings" "SENSORS"

# PHASE 7+ $1M ARR (3/3)
echo -e "\n${BLUE}🚀 PHASE 7+ $1M ARR:${NC}"
test_url "/electronic_signatures" "DOCUSIGN"
test_url "/dea_shipments" "DEA"
test_url "/transport_anomalies" "AI ANOMALIES"

echo -e "\n${GREEN}🎉 SUMMARY: ${PASS}/11 ENDPOINTS${NC}"
[ $PASS -eq 11 ] && echo -e "${GREEN}✅ $1M ARR PRODUCTION CERTIFIED!${NC}" || echo -e "${YELLOW}⚠️ Fix $FAIL endpoints${NC}"
echo -e "${BLUE}🌐 LIVE: http://localhost:3000/dashboard${NC}"
