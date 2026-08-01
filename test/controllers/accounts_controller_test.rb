require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    sign_in_as(users(:two))
  end

  test "should get show" do
    get accounts_show_url
    assert_response :success
  end
end
