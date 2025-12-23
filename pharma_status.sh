#!/bin/bash
echo "🚚 PHARMA TRANSPORT STATUS v1.0"
echo "=================================="
echo "Dashboard: $(curl -s -o /dev/null -w '%{http_code}' https://pharma-dashboard-s4g5.onrender.com/dashboard)"
echo "Pfizer: $(curl -s -o /dev/null -w '%{http_code}' https://pharma-dashboard-s4g5.onrender.com/pfizer)"
echo "DNS: $(dig +short pharmatranport.org @8.8.8.8)"
echo ""
echo "🔧 DNS SETUP: pharmatranport.org"
echo "A Record: @ → 216.24.57.1"
echo "CNAME: www → pharma-dashboard-s4g5.onrender.com"
# Link tester disabled in cron
