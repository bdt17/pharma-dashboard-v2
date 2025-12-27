#!/bin/bash

# GoDaddy DNS Auto-Fix
DOMAIN="yourdomain.com"        # CHANGE THIS
HOSTNAME="@ or www"           # CHANGE THIS  
API_KEY="your_api_key"        # Get from GoDaddy Developer
API_SECRET="your_api_secret"  # Get from GoDaddy Developer

# Get current IP
CURRENT_IP=$(curl -s https://api.ipify.org)

# Get GoDaddy DNS IP
GD_IP=$(curl -s -X GET \
  -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
  "https://api.godaddy.com/v1/domains/${DOMAIN}/records/A/${HOSTNAME}" | \
  jq -r '.[0].data')

echo "Current IP: $CURRENT_IP"
echo "GoDaddy IP: $GD_IP"

# Update if different
if [ "$GD_IP" != "$CURRENT_IP" ]; then
  echo "🔄 UPDATING DNS..."
  curl -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN}/records/A/${HOSTNAME}" \
    -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
    -H "Content-Type: application/json" \
    -d "[{\"data\": \"$CURRENT_IP\"}]" && \
  echo "✅ DNS FIXED! New IP: $CURRENT_IP"
else
  echo "✅ DNS already correct!"
fi
