require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'belongs to member association' do
    assert_equal members(:one), dividends(:one).member
  end

  test 'has one pay out association' do
    assert_equal pay_outs(:one), dividends(:pay_out_complete).pay_out

    dividends(:pay_out_complete).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      pay_outs(:one).reload
    end
  end

  test 'owed scope' do
    assert_includes Dividend.owed, Dividend.issued.first
    assert_includes Dividend.owed, Dividend.pending_pay_out.first
    assert_includes Dividend.owed, Dividend.pay_out_complete.first

    assert_not_includes Dividend.owed, Dividend.manually_recontributed.first
    assert_not_includes Dividend.owed, Dividend.auto_recontributed.first
  end

  test 'before save check for transaction_identifier check' do
    dividend = dividends(:pending_pay_out)

    assert_predicate dividend, :pending_pay_out?

    dividend.update! transaction_identifier: 'something'

    assert_predicate dividend, :pay_out_complete?
  end
end
