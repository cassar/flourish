require 'test_helper'

class AdminNotificationMailerTest < ActionMailer::TestCase
  test 'pay_out_requested' do
    mail = AdminNotificationMailer.with(dividend: dividends(:pending_pay_out)).pay_out_requested

    assert_equal [User::ADMIN_EMAIL], mail.to
    assert_match(/Pay Out Requested/, mail.subject)
  end
end
