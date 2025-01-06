require 'test_helper'

class NotificationPreferencesControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for edit' do
    get notification_preferences_path

    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    sign_in users(:one)

    get notification_preferences_path

    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    patch notification_preferences_path, params: { member: {
      notification_preferences_attributes: {
        '1' => { id: notification_preferences(:contribution_received).id, enabled: false }
      }
    } }

    assert_redirected_to new_user_session_path
  end

  test 'should update currency' do
    sign_in users(:one)

    assert_predicate notification_preferences(:contribution_received), :enabled

    patch notification_preferences_path, params: { member: {
      notification_preferences_attributes: {
        '1' => { id: notification_preferences(:contribution_received).id, enabled: false }
      }
    } }

    assert_redirected_to edit_user_registration_path
    assert_equal 'Preferences updated successfully.', flash[:success]
    notification_preferences(:contribution_received).reload

    assert_not_predicate notification_preferences(:contribution_received), :enabled
  end
end
