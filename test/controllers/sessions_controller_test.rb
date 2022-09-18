require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'get signin success' do
    get login_path

    assert_response :success
  end

  test 'post create redirects to verification_path' do
    post login_path params: { session: {
      email: users(:one).email,
      password: 'password'
    }}

    assert_response :redirect
    assert_redirected_to verification_path
  end

  test 'post create is an unprocessable entity' do
    post login_path params: { session: {
      email: users(:two).email,
      password: 'password'
    }}

    assert_response 422
  end

  test 'delete destroy redirects to root path' do
    delete logout_path

    assert_response :redirect
    assert_redirected_to root_path
  end
end
