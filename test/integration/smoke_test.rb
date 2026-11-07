require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest
  test 'home shows a sign in button when signed out' do
    get root_path

    assert_response :success
    assert_select 'a[href=?]', new_user_session_path, text: 'Sign in'
  end

  test 'home shows a sign out button when signed in' do
    sign_in users(:one)

    get root_path

    assert_response :success
    assert_select 'form[action=?] button', destroy_user_session_path, text: 'Sign out'
  end

  test 'sign in page renders' do
    get new_user_session_path

    assert_response :success
    assert_select 'input[type=submit][value=?]', 'Sign in'
  end

  test 'password reset page renders' do
    get new_user_password_path

    assert_response :success
  end

  test 'confirmation page renders' do
    get new_user_confirmation_path

    assert_response :success
  end

  test 'sign up is disabled' do
    assert_not_respond_to self, :new_user_registration_path
  end
end
