require 'test_helper'

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test 'renders login page' do
      get new_user_session_path

      assert_response :success
    end

    test 'login page has brand heading' do
      get new_user_session_path

      assert_select 'h1', text: /Take your/
    end

    test 'login page has email and password fields' do
      get new_user_session_path

      assert_select 'input[type=email]'
      assert_select 'input[type=password]'
    end

    test 'login page has submit button' do
      get new_user_session_path

      assert_select 'input[type=submit][value=?]', 'Log in'
    end

    test 'login page links to sign up' do
      get new_user_session_path

      assert_select 'a[href=?]', new_user_registration_path
    end

    test 'signs in user with valid credentials' do
      user = User.create!(email: 'test@example.com', password: 'password123', confirmed_at: Time.current)
      Member.create!(user:)

      post user_session_path, params: { user: { email: user.email, password: 'password123' } }

      assert_redirected_to root_path
    end

    test 'rejects invalid credentials' do
      post user_session_path, params: { user: { email: 'wrong@example.com', password: 'wrong' } }

      assert_response :unprocessable_entity
    end
  end
end
