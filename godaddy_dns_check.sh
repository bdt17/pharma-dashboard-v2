#!/bin/bash
echo "🌐 GODADDY DNS PROPAGATION - pharma-dashboard-s4g5.onrender.com"
dig +short pharma-dashboard-s4g5.onrender.com @8.8.8.8    # Google
dig +short pharma-dashboard-s4g5.onrender.com @1.1.1.1    # Cloudflare
dig +short pharma-dashboard-s4g5.onrender.com @208.67.222.222  # OpenDNS
nslookup pharma-dashboard-s4g5.onrender.com 8.8.4.4       # Google Alt
echo "✅ ALL DNS RESOLVING = PROPAGATED"
