require 'test_helper'

class AdminNotificationMailerTest < ActionMailer::TestCase
  test 'pay_out_notification' do
    email = AdminNotificationMailer.with(dividend: dividends(:one)).pay_out_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin-notifications@example.com'], email.from
    assert_equal ['admin@email.com'], email.to
    assert_equal 'Pay Out Requested', email.subject
    assert_equal read_fixture('pay_out.txt').join, email.body.to_s
  end
end
