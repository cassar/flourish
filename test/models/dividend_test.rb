require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'belongs to member association' do
    assert_equal members(:one), dividends(:one).member
  end

  test 'owed scope' do
    assert_includes Dividend.owed, dividends(:issued)
    assert_includes Dividend.owed, dividends(:pending_pay_out)
    assert_includes Dividend.owed, dividends(:pay_out_complete)
    assert_not_includes Dividend.owed, dividends(:manually_recontributed)
  end

  test 'before save check for receipt check' do
    dividend = dividends(:pending_pay_out)
    assert_predicate dividend, :pending_pay_out?

    dividend.update! receipt: 'something'

    assert_predicate dividend, :pay_out_complete?
  end
end
