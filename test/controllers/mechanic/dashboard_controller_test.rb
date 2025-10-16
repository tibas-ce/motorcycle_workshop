require "test_helper"

class Mechanic::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mechanic_dashboard_index_url
    assert_response :success
  end
end
