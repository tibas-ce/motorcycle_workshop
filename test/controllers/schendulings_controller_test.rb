require "test_helper"

class SchendulingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schendulings_index_url
    assert_response :success
  end

  test "should get show" do
    get schendulings_show_url
    assert_response :success
  end

  test "should get new" do
    get schendulings_new_url
    assert_response :success
  end

  test "should get create" do
    get schendulings_create_url
    assert_response :success
  end

  test "should get destroy" do
    get schendulings_destroy_url
    assert_response :success
  end
end
