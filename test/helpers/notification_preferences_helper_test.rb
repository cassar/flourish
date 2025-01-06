require 'test_helper'

class NotificationPreferencesHelperTest < ActionView::TestCase
  test 'notification emoji when enabled' do
    assert_equal '✅', notification_emoji(true)
  end

  test 'notification emjoi when disabled' do
    assert_equal '⛔️', notification_emoji(false)
  end
end
