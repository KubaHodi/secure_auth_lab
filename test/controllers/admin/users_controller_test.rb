require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:two)

    sign_in_as(@admin)
  end

  test "admin should get index" do
    get admin_users_url
    assert_response :success
  end

  test "admin should get show" do
    get admin_user_url(@admin)
    assert_response :success
  end
  
  test "regular user should not get index" do
    sign_in_as(@user)
    get admin_users_url
    assert_redirected_to root_url
  end

  test "regular user should not get show" do
    sign_in_as(@user)
    get admin_user_url(@user)
    assert_redirected_to root_url
  end

end
