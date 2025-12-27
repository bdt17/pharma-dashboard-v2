#!/bin/bash
while true; do 
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' https://pharma-transport-all.onrender.com/dashboard)
  echo "$(date): Dashboard=$STATUS $([ $STATUS = 200 ] && echo '✅ $23K ARR LIVE' || echo '🚨 DOWN')"
  sleep 300
done
