require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get pdf" do
    get reports_pdf_url
    assert_response :success
  end
end
