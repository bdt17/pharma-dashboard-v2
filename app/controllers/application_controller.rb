class ApplicationController < ActionController::API
  def current_user
    # Mock for testing - replace with real auth
    OpenStruct.new(id: 1, name: "Admin")
  end
end
