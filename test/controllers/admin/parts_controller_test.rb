require "test_helper"

class Admin::PartsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_parts_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_parts_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_parts_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_parts_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_parts_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_parts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_parts_destroy_url
    assert_response :success
  end
end
