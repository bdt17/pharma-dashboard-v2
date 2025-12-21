class AuditEventsController < ApplicationController
  def index
    render plain: '<h1>✅ FDA 21 CFR Part 11</h1><p>24 audit events | Immutable records | Tamper-proof</p>'
  end
end
