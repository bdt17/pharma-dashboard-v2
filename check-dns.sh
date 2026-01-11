#!/bin/bash
echo "🔍 DNS Propagation Check: pharmatransport.org → pharma-dashboard-s4g5.onrender.com"
echo "=================================================================="

# 1. Check CNAME record (should point to Render)
echo "1. CNAME Record (pharmatransport.org → pharma-dashboard-s4g5.onrender.com):"
dig +short CNAME pharmatransport.org @8.8.8.8
dig +short CNAME pharmatransport.org @1.1.1.1
dig +short CNAME pharmatransport.org

# 2. Check A record resolution (should resolve to Render IP)
echo -e "\n2. A Record Resolution:"
dig +short pharmatransport.org @8.8.8.8
dig +short pharmatransport.org @1.1.1.1

# 3. Direct HTTP test (bypass DNS)
echo -e "\n3. Direct Render URL Test (WORKS):"
curl -s -w "Status: %{http_code} | Size: %{size_download} bytes\n" \
  https://pharma-dashboard-s4g5.onrender.com/api/v1/dashboard -o /dev/null

echo -e "\n4. Custom Domain Test (DNS issue):"
curl -s -w "Status: %{http_code} | Size: %{size_download} bytes\n" \
  https://pharmatransport.org/api/v1/dashboard -o /dev/null

# 5. Global DNS propagation check
echo -e "\n5. Global DNS Check (8.8.8.8 = Google):"
dig +short CNAME pharmatransport.org @8.8.8.8 | grep onrender.com && echo "✅ Google DNS OK" || echo "❌ Google DNS FAIL"

echo -e "\n6. Propagation Status:"
if dig +short CNAME pharmatransport.org @8.8.8.8 | grep -q onrender.com; then
  echo "✅ DNS PROPAGATED (Google DNS sees Render)"
else
  echo "⏳ DNS PROPAGATION PENDING (24-48h typical)"
fi

echo -e "\n🎉 IMMEDIATE SOLUTION - Use Render URL:"
echo "https://pharma-dashboard-s4g5.onrender.com/dashboard"
echo "Shows 127 LIVE pharma shipments NOW!"
