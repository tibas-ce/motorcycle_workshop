require "test_helper"

class Mechanic::ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mechanic_reviews_index_url
    assert_response :success
  end

  test "should get show" do
    get mechanic_reviews_show_url
    assert_response :success
  end

  test "should get new" do
    get mechanic_reviews_new_url
    assert_response :success
  end

  test "should get create" do
    get mechanic_reviews_create_url
    assert_response :success
  end

  test "should get edit" do
    get mechanic_reviews_edit_url
    assert_response :success
  end

  test "should get update" do
    get mechanic_reviews_update_url
    assert_response :success
  end
end
