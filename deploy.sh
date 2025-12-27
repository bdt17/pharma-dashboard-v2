#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# PHARMA TRANSPORT — RENDER DEPLOYMENT SCRIPT
# Zero-downtime deployment with health checks
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Configuration
RENDER_API_KEY="${RENDER_API_KEY:-your-render-api-key}"
RENDER_SERVICE_ID="${RENDER_SERVICE_ID:-srv-xxxxx}"
DEPLOY_HOST="${DEPLOY_HOST:-pharma-transport.onrender.com}"
BRANCH="${1:-main}"

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║  🚀 PHARMA TRANSPORT — PRODUCTION DEPLOYMENT                          ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1: Git Operations
# ─────────────────────────────────────────────────────────────────────────────
echo "📦 Step 1: Preparing Git commit..."

git checkout $BRANCH 2>/dev/null || git checkout -b $BRANCH

# Stage all changes
git add -A

# Check if there are changes to commit
if git diff --staged --quiet; then
  echo "   ℹ️  No changes to commit"
else
  git commit -m "Deploy: Phase 12 Investor Demo

- FDA 21 CFR Part 11 compliant audit logging
- Real-time fleet tracking dashboard
- Temperature excursion monitoring
- Hash-chain verified audit trail

🤖 Generated with Claude Code

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
  echo "   ✅ Changes committed"
fi

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2: Push to Remote
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "📤 Step 2: Pushing to origin/$BRANCH..."
git push origin $BRANCH
echo "   ✅ Pushed to remote"

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3: Trigger Render Deploy (if API key configured)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "🌐 Step 3: Triggering Render deployment..."

if [ "$RENDER_API_KEY" != "your-render-api-key" ]; then
  # Trigger deploy via Render API
  curl -s -X POST "https://api.render.com/v1/services/$RENDER_SERVICE_ID/deploys" \
    -H "Authorization: Bearer $RENDER_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"clearCache": false}' | jq .
  echo "   ✅ Deploy triggered via Render API"
else
  echo "   ℹ️  Render auto-deploys on push (API key not configured)"
  echo "   ℹ️  Waiting 60s for deploy to start..."
  sleep 60
fi

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4: Health Check
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "🏥 Step 4: Running health checks..."

MAX_ATTEMPTS=30
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo "   Attempt $ATTEMPT/$MAX_ATTEMPTS..."

  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$DEPLOY_HOST/dashboard" || echo "000")

  if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✅ Health check passed (HTTP $HTTP_CODE)"
    break
  fi

  if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "   ❌ Health check failed after $MAX_ATTEMPTS attempts"
    exit 1
  fi

  ATTEMPT=$((ATTEMPT + 1))
  sleep 10
done

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5: Verify API
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "🔐 Step 5: Verifying API endpoints..."

API_CHECK=$(curl -s -o /dev/null -w "%{http_code}" "https://$DEPLOY_HOST/api/v1/tenant" \
  -H "X-API-Key: $PHARMA_API_KEY" || echo "000")

if [ "$API_CHECK" = "200" ] || [ "$API_CHECK" = "401" ]; then
  echo "   ✅ API responding (HTTP $API_CHECK)"
else
  echo "   ⚠️  API check: HTTP $API_CHECK"
fi

# ─────────────────────────────────────────────────────────────────────────────
# COMPLETE
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║  ✅ DEPLOYMENT COMPLETE                                               ║"
echo "╠═══════════════════════════════════════════════════════════════════════╣"
echo "║  🌐 Production:  https://$DEPLOY_HOST                    ║"
echo "║  📊 Dashboard:   https://$DEPLOY_HOST/dashboard          ║"
echo "║  🔐 API:         https://$DEPLOY_HOST/api/v1             ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Environment variables needed in Render:"
echo "  DATABASE_URL       = postgres://..."
echo "  RAILS_ENV          = production"
echo "  SECRET_KEY_BASE    = $(openssl rand -hex 64 | head -c 64)..."
echo "  RAILS_MASTER_KEY   = <from config/master.key>"
echo ""
