require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect if hcaptcha fails' do
      RegistrationsController.any_instance.stubs(:verify_hcaptcha).returns(false)

      assert_no_difference 'User.count' do
        post user_registration_path, params: { user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        } }
      end

      assert_redirected_to new_user_registration_path
    end

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

    test 'should create member notification preferences' do
      assert_difference 'NotificationPreference.count', NotificationPreference.notification_names.count do
        post user_registration_path, params: { user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        } }
      end
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
