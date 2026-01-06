class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard:#{current_user&.id || 'global'}"
  end

  def unsubscribed
    # Cleanup
  end
end
