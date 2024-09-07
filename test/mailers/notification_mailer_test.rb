require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test 'new_contribution' do
    email = NotificationMailer.with(contribution: contributions(:one)).new_contribution

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Contribution has been Received', email.subject
    assert_equal read_fixture('contribution_received.txt').join, email.body.to_s
  end

  test 'new_dividend' do
    email = NotificationMailer.with(dividend: dividends(:one)).new_dividend

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'New Dividend Distributed', email.subject
    expected_content = read_fixture('new_dividend.txt').join.gsub('{{id}}', dividends(:one).id.to_s)
    assert_equal expected_content, email.body.to_s
  end

  test 'paid_out' do
    email = NotificationMailer.with(dividend: dividends(:paid_out)).paid_out

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Paid Out', email.subject
    assert_equal read_fixture('paid_out.txt').join, email.body.to_s
  end

  test 'dividend_recontributed' do
    email = NotificationMailer.with(dividend: dividends(:recontributed)).dividend_recontributed

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Automatically Recontributed', email.subject
    assert_equal read_fixture('dividend_recontributed.txt').join, email.body.to_s
  end
end
