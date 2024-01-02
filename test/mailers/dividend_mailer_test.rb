require 'test_helper'

class DividendMailerTest < ActionMailer::TestCase
  test 'pay_out_notification' do
    email = DividendMailer.with(dividend: dividends(:one)).pay_out_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['admin@email.com'], email.to
    assert_equal 'user@email.com has requested a Pay Out', email.subject
    assert_equal read_fixture('pay_out.txt').join, email.body.to_s
  end

  test 'new_dividend_notification' do
    email = DividendMailer.with(dividend: dividends(:one)).new_dividend_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'New Dividend Distributed', email.subject
    assert_equal read_fixture('new_dividend.txt').join, email.body.to_s
  end
end
