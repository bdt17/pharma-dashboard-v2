class DriversController < ApplicationController
  def new
    @driver = Driver.new
    render layout: 'dashboard'
  end
  
  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to dashboard_path, notice: 'Driver added!'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  def driver_params
    params.require(:driver).permit(:name, :phone)
  end
end
