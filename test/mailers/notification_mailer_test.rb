require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test 'contribution_received' do
    mail = NotificationMailer.with(contribution: contributions(:one)).contribution_received

    assert_equal [members(:one).user.email], mail.to
    assert_match(/Contribution/, mail.subject)
    assert_match(members(:one).user.email, mail.body.encoded)
  end

  test 'dividend_received' do
    mail = NotificationMailer.with(dividend: dividends(:one)).dividend_received

    assert_equal [members(:one).user.email], mail.to
    assert_match(/Dividend/, mail.subject)
  end

  test 'dividend_paid_out' do
    mail = NotificationMailer.with(pay_out: pay_outs(:pay_out_complete)).dividend_paid_out

    assert_equal [members(:one).user.email], mail.to
    assert_match(/Paid Out/, mail.subject)
  end

  test 'dividend_automatically_recontributed' do
    mail = NotificationMailer.with(dividend: dividends(:auto_recontributed)).dividend_automatically_recontributed

    assert_equal [members(:one).user.email], mail.to
    assert_match(/Automatically Recontributed/, mail.subject)
  end

  test 'distribution_settled' do
    mail = NotificationMailer.with(distribution: distributions(:two), user: users(:one)).distribution_settled

    assert_equal [users(:one).email], mail.to
    assert_match(/Settled/, mail.subject)
  end
end
