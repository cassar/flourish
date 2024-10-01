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
    assert_equal read_fixture('contribution_received.txt').join, email.body.to_s
  end

  test 'dividend_received' do
    email = NotificationMailer.with(dividend: dividends(:one)).dividend_received

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'New Dividend Distributed', email.subject
    expected_content = read_fixture('dividend_received.txt').join.gsub('{{id}}', dividends(:one).id.to_s)
    assert_equal expected_content, email.body.to_s
  end

  test 'dividend_paid_out' do
    email = NotificationMailer.with(dividend: dividends(:pay_out_complete)).dividend_paid_out

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Paid Out', email.subject
    assert_equal read_fixture('dividend_paid_out.txt').join, email.body.to_s
  end

  test 'dividend_automatically_recontributed' do
    email = NotificationMailer.with(dividend: dividends(:auto_recontributed)).dividend_automatically_recontributed

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Automatically Recontributed', email.subject
    assert_equal read_fixture('dividend_automatically_recontributed.txt').join, email.body.to_s
  end

  test 'distribution_settled' do
    email = NotificationMailer.with(distribution: distributions(:one), user: users(:one)).distribution_settled

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Distribution #1 has Settled', email.subject
    assert_equal read_fixture('distribution_settled.txt').join, email.body.to_s
  end
end
