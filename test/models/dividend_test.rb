require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'belongs to member association' do
    assert_equal members(:one), dividends(:one).member
  end

  test 'outstanding association' do
    assert_includes Dividend.outstanding, dividends(:issued)
    assert_includes Dividend.outstanding, dividends(:pending_pay_out)
    assert_not_includes Dividend.outstanding, dividends(:paid_out)
  end

  test 'before save check for receipt check' do
    dividend = dividends(:pending_pay_out)
    assert_predicate dividend, :pending_pay_out?

    dividend.update! receipt: 'something'

    assert_predicate dividend, :paid_out?
  end
end
