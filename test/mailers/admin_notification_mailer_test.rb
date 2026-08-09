require 'test_helper'

class AdminNotificationMailerTest < ActionMailer::TestCase
  test 'pay_out_requested' do
    mail = AdminNotificationMailer.with(dividend: dividends(:pending_pay_out)).pay_out_requested

    assert_equal [User::ADMIN_EMAIL], mail.to
    assert_match(/Pay Out Requested/, mail.subject)
  end

  test 'expenses_added' do
    mail = AdminNotificationMailer.with(expenses: [expenses(:one), expenses(:two)]).expenses_added

    assert_equal [User::ADMIN_EMAIL], mail.to
    assert_match(/New Expenses Added/, mail.subject)
    assert_match(expenses(:one).name, mail.body.encoded)
  end
end
