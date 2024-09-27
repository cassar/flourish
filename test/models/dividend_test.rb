require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'belongs to member association' do
    assert_equal members(:one), dividends(:one).member
  end

  test 'owed scope' do
    assert_includes Dividend.owed, Dividend.issued.first
    assert_includes Dividend.owed, Dividend.pending_pay_out.first
    assert_includes Dividend.owed, Dividend.pay_out_complete.first

    assert_not_includes Dividend.owed, Dividend.manually_recontributed.first
    assert_not_includes Dividend.owed, Dividend.auto_recontributed.first
  end

  test 'before save check for receipt check' do
    dividend = dividends(:pending_pay_out)
    assert_predicate dividend, :pending_pay_out?

    dividend.update! receipt: 'something'

    assert_predicate dividend, :pay_out_complete?
  end

  test 'aggregate_status' do
    assert_equal :paid_out, Dividend.aggregate_status(:pending_pay_out)
  end
end
