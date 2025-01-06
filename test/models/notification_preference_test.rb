require 'test_helper'

class NotificationPreferenceTest < ActiveSupport::TestCase
  test 'belongs to member association' do
    assert_equal members(:one), notification_preferences(:contribution_received).member
  end

  test 'validates notification name unique to member' do
    taken_notification_name = notification_preferences(:dividend_received).notification_name
    error = assert_raises ActiveRecord::RecordInvalid do
      notification_preferences(:contribution_received).update! notification_name: taken_notification_name
    end

    assert_match 'Notification name has already been taken', error.message
  end

  test 'validates notification name reused across members' do
    first_member_preference = notification_preferences(:contribution_received)
    second_member_preference = notification_preferences(:contribution_received_disabled)

    assert_predicate  first_member_preference, :valid?
    assert_predicate  second_member_preference, :valid?

    assert_equal first_member_preference.notification_name, second_member_preference.notification_name
  end
end
