require "test_helper"

class Admin::MechanicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_mechanics_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_mechanics_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_mechanics_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_mechanics_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_mechanics_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_mechanics_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_mechanics_destroy_url
    assert_response :success
  end
end
