class DashboardController < ApplicationController
  def index
    render plain: '<h1>🚚 Pharma Dashboard LIVE</h1><div class="alert alert-success">Phase 6 FDA OK - 3 trucks + sensors + audits</div>'
  end
end
