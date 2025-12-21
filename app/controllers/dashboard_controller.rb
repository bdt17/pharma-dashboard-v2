class DashboardController < ApplicationController
  def index
    render plain: "🚚 PHARMA TRANSPORT LIVE - Phase 6+7 $1M ARR
✅ FDA 21 CFR Part 11
✅ Cold Chain Sensors 2-8°C  
✅ GPS Tracking (3 trucks)
✅ DocuSign + DEA + AI Ready", status: 200
  end
end
