module Api
  module V1
    class DashboardController < ApplicationController
      before_action :authenticate_user!  # Adjust to your auth
      
      def index
        render json: DashboardService.new(current_user).summary
      end
    end
  end
end
