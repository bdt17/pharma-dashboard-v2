require "test_helper"

class PartnersControllerTest < ActionDispatch::IntegrationTest
  test "should get pfizer" do
    get partners_pfizer_url
    assert_response :success
  end
end
