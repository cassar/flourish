require 'test_helper'

class AdminNotificationMailerTest < ActionMailer::TestCase
  test 'pay_out_requested' do
    email = AdminNotificationMailer.with(dividend: dividends(:one)).pay_out_requested

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin-notifications@example.com'], email.from
    assert_equal ["admin@#{ENV.fetch('DOMAIN', nil)}"], email.to
    assert_equal 'Pay Out Requested', email.subject
    assert_equal read_fixture('pay_out_requested.txt').join, email.body.to_s
  end
end
