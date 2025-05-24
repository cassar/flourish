require 'test_helper'

class AdminNotificationMailerTest < ActionMailer::TestCase
  test 'pay_out_requested' do
    email = AdminNotificationMailer.with(dividend: dividends(:pending_pay_out)).pay_out_requested

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin-notifications@flourish.test'], email.from
    assert_equal ['admin@flourish.test'], email.to
    assert_equal 'Pay Out Requested', email.subject
  end

  test 'expenses_added' do
    expenses = [expenses(:one), expenses(:two)]
    email = AdminNotificationMailer.with(expenses:).expenses_added

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin-notifications@flourish.test'], email.from
    assert_equal ['admin@flourish.test'], email.to
    assert_equal 'New Expenses Added', email.subject
  end
end
