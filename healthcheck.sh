#!/bin/bash
echo "=== FDA PHARMA TRACKER ==="
DASH=$(timeout 10 curl -s -o /dev/null -w "%{http_code}" https://pharma-dashboard.onrender.com)
echo "Dashboard: ${DASH:-TIMEOUT}"
API=$(timeout 10 curl -s -o /dev/null -w "%{http_code}" https://pharma-api-brax.onrender.com/batches)
echo "API: ${API:-TIMEOUT}"
BATCOUNT=$(timeout 5 curl -s https://pharma-api-brax.onrender.com/batches | grep -c '"lot_number"')
echo "Batches: ${BATCOUNT:-0}"
if [ "${DASH:-0}" = "200" ] && [ "${API:-0}" = "200" ] && [ "${BATCOUNT:-0}" -gt 0 ]; then
  echo "✅ PRODUCTION READY - ${BATCOUNT} batches LIVE"
else
  echo "❌ CHECK SERVICES"
fi
echo "=== COMPLETE ==="
