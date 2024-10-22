require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test 'contribution_received' do
    email = NotificationMailer.with(contribution: contributions(:one)).contribution_received

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Contribution has been Received', email.subject
  end

  test 'dividend_received' do
    email = NotificationMailer.with(dividend: dividends(:one)).dividend_received

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'New Dividend Distributed', email.subject
  end

  test 'dividend_paid_out' do
    email = NotificationMailer.with(dividend: dividends(:pay_out_complete)).dividend_paid_out

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Paid Out', email.subject
  end

  test 'dividend_automatically_recontributed' do
    email = NotificationMailer.with(dividend: dividends(:auto_recontributed)).dividend_automatically_recontributed

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Automatically Recontributed', email.subject
  end

  test 'distribution_settled' do
    email = NotificationMailer.with(distribution: distributions(:one), user: users(:one)).distribution_settled

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Distribution #1 has Settled', email.subject
  end

  test 'distribution_preview' do
    email = NotificationMailer.with(user: users(:one)).distribution_preview
    NextDistributionService.stubs(:date_formatted).returns('Fri, 04 Oct 2024')
    WeeklyExpensesService.stubs(:last_weeks_expenses).returns([expenses(:one), expenses(:two)])
    WeeklyExpensesService.stubs(:last_weeks_expeneses_total_formatted).returns('$21.00 AUD')

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Distribution #3 Preview', email.subject
  end
end
