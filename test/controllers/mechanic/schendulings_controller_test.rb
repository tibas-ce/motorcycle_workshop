require "test_helper"

class Mechanic::SchendulingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mechanic_schendulings_index_url
    assert_response :success
  end

  test "should get show" do
    get mechanic_schendulings_show_url
    assert_response :success
  end
end
