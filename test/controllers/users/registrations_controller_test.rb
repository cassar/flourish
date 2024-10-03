require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test 'should create user and member' do
      assert_difference 'Member.count', 1 do
        post user_registration_path, params: { user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        } }
      end

      user = User.find_by(email: 'test@example.com')
      member = Member.find_by(user_id: user.id)

      assert_not_nil user
      assert_not_nil member
    end

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
