require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    SessionsController::RATE_LIMIT_STORE.clear
  end

  teardown do
    SessionsController::RATE_LIMIT_STORE.clear
  end
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    sign_in_as(users(:two))
    assert_response :redirect
  end 

  test "should not create session with invalid credentials" do
    post session_url, params: { email_address: users(:two).email_address, password: "wrongpassword" }
    assert_response :redirect
    assert_redirected_to new_session_url
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "should not log in with many failed attempts" do
    10.times do
      post session_url, params: { email_address: users(:two).email_address, password: "wrongpassword" }
    end

    post session_url, params: {
    email_address: users(:two).email_address,
    password: "wrongpassword"
    }
    assert_response :redirect
    assert_redirected_to new_session_url
    assert_equal "Try again later.", flash[:alert]
  end

end
