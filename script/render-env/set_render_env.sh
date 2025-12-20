#!/bin/bash
# FIXED Render ENV vars script for Rails 8+

export DATABASE_URL="postgresql://pharma_gps_db_user:MQSytyZX5iAmmCpy1UXnNntYtf3gVBld@dpg-d52cbfshg0os73ehjhfg-a/pharma_gps_db"
export REDIS_URL="rediss://red-d52rrgi4d50c73b9rb2g:YOUR_PASSWORD@oregon-red-d52rrgi4d50c73b9rb2g.render.com:6379"
export RAILS_MASTER_KEY="your_32_character_key_here"

# FIXED: Rails 8+ secret command (no -e flag)
export SECRET_KEY_BASE=$(bundle exec rails secret)
export RAILS_ENV="production"

echo "✅ ENV VARS SET!"
echo "DATABASE_URL: ${DATABASE_URL:0:50}..."
echo "REDIS_URL:    ${REDIS_URL:0:50}..."
echo "RAILS_MASTER_KEY: ${RAILS_MASTER_KEY:0:10}..."
echo "SECRET_KEY_BASE:  ${SECRET_KEY_BASE:0:10}..."
echo "RAILS_ENV:    $RAILS_ENV"

echo "🚀 COPY THESE 5 LINES TO Render → Pharma_Transport_all → Environment:"
echo ""
echo "DATABASE_URL=\"$DATABASE_URL\""
echo "REDIS_URL=\"$REDIS_URL\""
echo "RAILS_MASTER_KEY=\"$RAILS_MASTER_KEY\""
echo "SECRET_KEY_BASE=\"$SECRET_KEY_BASE\""
echo "RAILS_ENV=production"
