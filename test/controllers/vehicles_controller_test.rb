require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  test "should get update_gps" do
    get vehicles_update_gps_url
    assert_response :success
  end
end
