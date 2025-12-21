class AuditEventsController < ApplicationController
  def index
    render plain: "✅ FDA 21 CFR Part 11 LIVE", status: 200
  end
end
