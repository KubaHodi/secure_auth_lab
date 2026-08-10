require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    @user.update!(password: "password", password_confirmation: "password")
    sign_in_as(users(:two))
  end

  test "logged users can access their account page" do
    get accounts_show_url
    assert_response :success
  end 

  test "unlogged users cannot access account" do
    sign_out
    get account_url
    assert_redirected_to new_session_url
  end

  test "wrong password cannot delete account" do
    assert_no_difference ("User.count") do
      delete account_url, params: { 
        password: "wrongpassword",
        confirm_deletion: "1" 
      }
    end
    assert_response :unprocessable_entity
  end

  test "correct password can delete account" do
    assert @user.authenticate("password")
    assert_difference ("User.count"), -1 do
      delete account_url, params: { 
        password: "password",
        confirm_deletion: "1" 
      }
    end
    assert_response :redirect
  end

  test "fixture password is correct" do
  assert @user.authenticate("password")
  end

end
