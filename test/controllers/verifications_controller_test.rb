require "test_helper"

class VerificationsControllerTest < ActionDispatch::IntegrationTest
  test 'get verification redirected to signin' do
    get verification_path

    assert_response :redirect
    assert_redirected_to login_path
  end

  test 'get verification success' do
    log_in_as users(:one)

    get verification_path

    assert_response :success
  end
end
