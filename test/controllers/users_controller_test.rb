require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'get signup success' do
    get signup_path

    assert_response :success
  end

  test 'post create redirects to verification_path' do
    post users_path params: { user: {
      email: 'user3@email.com',
      password: 'password',
      password: 'password'
    }}

    assert_response :redirect
    assert_redirected_to verification_path
  end

  test 'post create is an unprocessable entity' do
    post users_path params: { user: {
      email: users(:one).email,
      password: 'password',
      password: 'password'
    }}

    assert_response 422
  end
end
