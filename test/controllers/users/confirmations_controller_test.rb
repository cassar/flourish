require 'test_helper'

module Users
  class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
    test 'renders resend confirmation page' do
      get new_user_confirmation_path

      assert_response :success
    end

    test 'resend confirmation page has brand heading' do
      get new_user_confirmation_path

      assert_select 'h1', text: /Check your/
    end

    test 'resend confirmation page has email field' do
      get new_user_confirmation_path

      assert_select 'input[type=email]'
    end

    test 'resend confirmation page has submit button' do
      get new_user_confirmation_path

      assert_select 'input[type=submit][value=?]', 'Resend confirmation instructions'
    end

    test 'resend confirmation page links to login' do
      get new_user_confirmation_path

      assert_select 'a[href=?]', new_user_session_path
    end

    test 'sends confirmation instructions to existing unconfirmed user' do
      user = users(:unconfirmed)

      assert_emails 1 do
        post user_confirmation_path, params: { user: { email: user.email } }
      end

      assert_redirected_to new_user_session_path
    end

    test 'does not reveal whether email exists' do
      assert_emails 0 do
        post user_confirmation_path, params: { user: { email: 'nobody@example.com' } }
      end
    end

    test 'confirming an account signs the user in and redirects to the membership page' do
      user = users(:unconfirmed)

      get user_confirmation_path(confirmation_token: 'my_confirmation_token')

      assert_redirected_to membership_path
      assert_predicate user.reload, :confirmed?
    end
  end
end
