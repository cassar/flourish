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
  end

  test 'expenses_added' do
    expenses = [expenses(:one), expenses(:two)]
    email = AdminNotificationMailer.with(expenses:).expenses_added

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin-notifications@example.com'], email.from
    assert_equal ["admin@#{ENV.fetch('DOMAIN', nil)}"], email.to
    assert_equal 'New Expenses Added', email.subject
  end
end
