require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to check spam folder after successful registration' do
      assert_difference 'User.count' do
        post user_registration_path, params: { user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        } }
      end

      assert_redirected_to check_email_spam_path
    end
  end
end
